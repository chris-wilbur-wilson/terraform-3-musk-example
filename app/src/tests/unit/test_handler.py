import os
import pathlib
import boto3
import json
import sys
import mock
import moto

if os.getenv("RUNNING_IN_CONTAINER"):
    # Running via make test
    #sys.path.insert(1, '../../')
    sys.path.insert(1, 'src/function')
else:
    # running outside container
    sys.path.insert(1, 'app/src/function')

from handler import (
    strip_exif,
    strip_exif_and_upload
)

os.chdir(pathlib.Path(__file__).parent.absolute())

def test_strip_exif():
    source = '../test-files/Canon_40D.jpg'
    dest = 'test-output/Canon_40D.jpg'
    return_value = strip_exif(source, dest)
    assert return_value == True

@moto.mock_s3
def test_strip_exif_and_upload_success():
    #arrange
    source_bucket = "source-bucket"
    destination_bucket = "destination-bucket"
    key = "a/path/to/a.jpg"
    kms_key_id = "1234"

    os_values = {
        "DESTINATION_BUCKET": destination_bucket,
        "KMS_KEY_ID": kms_key_id
    }

    with mock.patch.dict(os.environ, os_values):

        # s3 test fixture
        client_s3 = boto3.client('s3', region_name="us-east-1")
        client_s3.create_bucket(Bucket=source_bucket)
        client_s3.create_bucket(Bucket=destination_bucket)
        file_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "../test-files/Canon_40D.jpg")
        with open(file_path, 'rb') as jpg_file:
            jpg_file.seek(0)
            client_s3.put_object(
                Bucket=source_bucket,
                Key=key,
                Body=jpg_file.read()
            )

        # act
        result = strip_exif_and_upload(client_s3, source_bucket, key)

    #assert
    assert result == "ok"

def test_strip_exif_and_upload_not_jpg():
    #arrange
    source_bucket = "source-bucket"
    key = "a/path/to/not-a-jpg.txt"

    # act
    result = strip_exif_and_upload(None, source_bucket, key)

    #assert
    assert result == "Not a jpg"
