#!/bin/bash
set -eo pipefail

dir=`dirname "$0"`
zip="lambda.zip"
cd ${dir}

parentdir="$(dirname "${dir}")"
echo -e "\033[1;33m--- Packaging ${parentdir} ---\033[0m"

venv_dir="../.venv/deploy-env"

echo "creating virtual python env"
python3 -m venv ${venv_dir} &> /dev/null

echo "activating virtual python env"
source ${venv_dir}/bin/activate &> /dev/null

echo "upgrading pip"
pip install --upgrade pip &> /dev/null

echo "installing package requirements"
pip install -r ${dir}/../function/requirements.txt &> /dev/null

[[ -d /app/zips ]] || mkdir /app/zips

echo "zipping up function"
rm -f /app/zips/${zip} &> /dev/null 
cd ${dir}/${venv_dir}/lib/python3.*/site-packages &> /dev/null
zip -r9 /app/zips/${zip} .  &> /dev/null
cd ${dir}/../function &> /dev/null
zip -u /app/zips/${zip} *.py &> /dev/null

echo "deactivating virtual python env"
deactivate

rm -r ${venv_dir}
