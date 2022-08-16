#!/bin/bash
# arg[1] csv file directory
RESULT_DIR=target/jmeter/results
mvn clean
{
	read
	while IFS=',', read -r testNum IP port URI username password verb bodyFile numDependencies listDependencies numThreads requestsPerThread rampUpTime || [ -n "$rampUpTime" ]
	do
		echo "Test Number : $testNum"
		mvn install -DtestNum=$testNum -DIP=$IP -Dport=$port -DURI=${URI//////} -Dusername=$username -Dpassword=$password -Dverb=$verb -DbodyFile=$bodyFile -DnumDependencies=$numDependencies -DlistDependencies=$listDependencies -DnumThreads=$numThreads -DrequestsPerThread=$requestsPerThread -DrampUpTime=$rampUpTime -Dreportgenerator.properties.overall_granularity=1000 &
		wait

		mv target/jmeter/results/*-ppdm-test.csv target/jmeter/results/test-$testNum-jtl.csv
		mv target/jmeter/logs/ppdm-test.jmx.log target/jmeter/logs/test-$testNum.log
		mv target/jmeter/reports/ppdm-test target/jmeter/reports/test-$testNum
		mv target/????????-????-????-????-???????????? target/test-$testNum-internal-files
	done
} < src/test/jmeter/$1