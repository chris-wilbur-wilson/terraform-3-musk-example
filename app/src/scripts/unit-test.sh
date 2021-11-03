#!/bin/bash
set -eo pipefail

tests_path="/app/src/tests/unit"
venv_dir="${tests_path}/.venv"

echo "creating venv"
python3 -m venv ${venv_dir} &> /dev/null

source "${venv_dir}/bin/activate" &> /dev/null

pip install --upgrade pip &> /dev/null
pip install -r "${tests_path}/requirements.txt" &> /dev/null

echo "running ${tests_path}"
python3 -m pytest -W ignore::DeprecationWarning --log-cli-level INFO -s "${tests_path}"

deactivate

rm -r ${venv_dir}
