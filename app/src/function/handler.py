import logging
import boto3
import os
import uuid
from PIL import Image

from exceptions import APIException

log = logging.getLogger()
log.setLevel(logging.INFO)

def handler(event, context):
    """Summary
    Lambda handler to strip exif and upload to different bucket

    Parameters:
        event: The event argument carries the input parameters for the function and is in JSON syntax
        context: When Lambda runs your function, it passes a context object to the handler. This object provides methods
        and properties that provide information about the invocation, function, and execution environment.
    """

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]
    s3 = boto3.client("s3")

    result = strip_exif_and_upload(s3, bucket, key)
    log.info("log_status: %s", result)

    return result

def strip_exif_and_upload(s3, bucket, key):
    """Summary
    Download object from source S3 bucket
    Strip Exif
    Upload object to dest S3 bucket

    Parameters:
        s3: boto3.client("s3")
        bucket: Bucket to download from
        key_name: key name to use
    Returns:
        "Ok": if successful
        "Not a jpg": if file isn't a jpg
    """

    return_value = "ok"
    if not key.endswith('.jpg'):
        return_value = "Not a jpg"
    else:
        orig_location = '/tmp/exif_handler_orig_{}.jpg'.format(uuid.uuid4())
        stripped_location = '/tmp/exif_handler_stripped_{}.jpg'.format(uuid.uuid4())
        download_from_s3_bucket(s3, bucket, key, orig_location)
        strip_exif(orig_location, stripped_location)
        destination_bucket = os.environ.get("DESTINATION_BUCKET")
        upload_file_to_s3_bucket(s3, destination_bucket, key, stripped_location)
        os.remove(orig_location)
        os.remove(stripped_location)

    return return_value

def strip_exif(orig_location, stripped_location):
    """Summary
    Opens file from orig_location and saves it to stripped_location with exif stripped

    Parameters:
        orig_location: Location of original image
        stripped_location: Location of stripped image
    Returns:
        True: if exif has been stripped successfully
    """

    image = Image.open(orig_location)
    image.save(stripped_location)
    return True

def download_from_s3_bucket(s3, bucket, key_name, location):
    """Summary
    Download object from an S3 bucket

    Parameters:
        s3: boto3.client("s3")
        bucket: Bucket to download from
        key_name: key name to use
        location: local file path location to download the object to
    Raises:
        ValueError: If bucket, key_name or contents are missing
        APIException: If download fails
    Returns:
        True: if contents have been downloaded successfully
    """

    if (bucket is None or bucket == ''):
        raise ValueError("The bucket cannot be empty")

    if (key_name is None or key_name == ''):
        raise ValueError("The key_name cannot be empty")

    if (location is None or location == ''):
        raise ValueError("The location cannot be empty")

    log.info("Downloading from s3 bucket: '%s' with key '%s' to local file: '%s'", bucket, key_name, location)

    # Download from the bucket
    try:
        s3.download_file(Bucket=bucket, Key=key_name, Filename=location)
    except (Exception) as error:
        raise APIException("AWS S3: Unable to download object from bucket.") from error

    return True

def upload_file_to_s3_bucket(s3, bucket, key_name, location):
    """Summary
    Upload contents to an S3 bucket

    Parameters:
        s3: boto3.client("s3")
        bucket: Bucket to upload to
        key_name: key name to use
        location: The location of the file to upload
    Raises:
        ValueError: If bucket, key_name or contents are missing
        APIException: If upload fails
    Returns:
        True: if contents have been uploaded successfully
    """

    if (bucket is None or bucket == ''):
        raise ValueError("The bucket cannot be empty")

    if (key_name is None or key_name == ''):
        raise ValueError("The key_name cannot be empty")

    if (location is None or location == ''):
        raise ValueError("The location cannot be empty")

    kms_key_id = os.environ.get("KMS_KEY_ID")
    log.info("Uploading file to s3 bucket: '%s' with key name '%s' and KMS Key ID '%s'", bucket, key_name, kms_key_id)

    # Upload the contents to the bucket
    try:
        s3.upload_file(location, bucket, key_name, ExtraArgs={"ServerSideEncryption": "aws:kms", "SSEKMSKeyId": kms_key_id})
    except (Exception) as error:
        raise APIException("AWS S3: Unable to upload object to bucket.") from error

    return True
