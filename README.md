## Prerequisites

This project requires GNU Make, Docker and docker-compose. I'm using Ubuntu 20.04.3 and the versions I've tested this on are:

* Make - 4.2.1
* Docker - 20.10.9
* Docker-compose - 1.29.2

=====++====You can check if Make is installed by running

```sh
make --version
```

If it's not installed, you can install it on Ubuntu by running:

```sh
sudo apt-get install build-essential
```

Or if you're on Windows, the easiest way to install is via Chocolatey:

```powershell
choco install make
```

Note if you're running on Windows, some of the paths in the docker-compose file might need to be changed. You might also have issues of the permissions on your .aws files are incorrect. I don't have a Windows machine to test this on.

## Running this project

Firstly, you need to set your AWS credentials, either in your local .aws file or by setting environment variables.

Secondly, variables for this project are stored in infra/terraform/config/config1.tfvars. You'll need to change the following setting:

```hcl
# This IAM role will have permissions to assume the Reader and Writer roles created within this project
assume_role_name = << set this to a role that you are able to assume >>
```

### Building and deploying

Simply run:

```sh
# This will test and package the lambda, then deploy it all to AWS
make
```

Or run the commands separately:

```sh
make app__unit_test
make app__package
make infra__plan
make infra__deploy
```

I've also written a few simple scripts to test this out:

```sh
make infra__test_reader_write_fail_1
make infra__test_reader_write_fail_2
make infra__test_writer_write_succeed
make infra__test_writer_write_fail
make infra__test_reader_read_succeed
make infra__test_reader_read_fail
make infra__test_reader_cant_assume_writer
make infra__test_writer_cant_assume_reader
```

And when you're finished

```sh
make infra__destroy
```
