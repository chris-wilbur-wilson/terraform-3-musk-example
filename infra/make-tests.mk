.PHONY: test_reader_write_fail_1
test_reader_write_fail_1:
	echo -e --- $(CYAN)Checking Reader can\'t write to source ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-reader-write-fail-1.sh"

.PHONY: test_reader_write_fail_2
test_reader_write_fail_2:
	echo -e --- $(CYAN)Checking Reader can\'t write to dest ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-reader-write-fail-2.sh"

.PHONY: test_writer_write_succeed
test_writer_write_succeed:
	echo -e --- $(CYAN)Checking Writer can write to source ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-writer-write-succeed.sh"

.PHONY: test_writer_write_fail
test_writer_write_fail:
	echo -e --- $(CYAN)Checking Writer can\'t write to destination ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-writer-write-fail.sh"

.PHONY: test_reader_read_succeed
test_reader_read_succeed:
	echo -e --- $(CYAN)Checking Reader can read from dest ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-reader-read-succeed.sh"

.PHONY: test_reader_read_fail
test_reader_read_fail:
	echo -e --- $(CYAN)Checking Reader can\'t read from source ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-reader-read-fail.sh"

.PHONY: test_reader_cant_assume_writer
test_reader_cant_assume_writer:
	echo -e --- $(CYAN)Checking Reader can\'t assume writer ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-reader-cant-assume-writer.sh"

.PHONY: test_writer_cant_assume_reader
test_writer_cant_assume_reader:
	echo -e --- $(CYAN)Checking Writer can\'t assume reader ...$(NC)
	$(RUN_TF_BASH) -c "test-scripts/test-writer-cant-assume-reader.sh"
