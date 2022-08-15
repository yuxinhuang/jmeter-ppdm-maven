#!/bin/bash
# arg[1] csv file directory
RESULT_DIR=target/jmeter/results
mvn clean
{
	read
	while IFS=',', read -r testNum IP port URI username password verb bodyFile numDependencies dependencies numThreads requestsPerThread rampUpTime || [ -n "$rampUpTime" ]
	do
		echo "Test Number : $testNum"
		mvn install -DtestNum=$testNum -DIP=$IP -Dport=$port -DURI=${URI//////} -Dusername=$username -Dpassword=$password -Dverb=$verb -DbodyFile=$bodyFile -DnumDependencies=$numDependencies -Ddependencies=$dependencies -DnumThreads=$numThreads -DrequestsPerThread=$requestsPerThread -DrampUpTime=$rampUpTime -Djmeter.reportgenerator.overall_granularity=1000 &
		wait
		TEST_DIR=$RESULT_DIR/test-$testNum
		mkdir $TEST_DIR
		if ! [ -d target/jmeter/listener-data ]; then
			mkdir target/jmeter/listener-data
		else
			rm -r target/jmeter/listener-data/*
		fi
		POST_DIR=target/jmeter/listener-data/failed-post-requests
		if [ $verb == "POST" ]; then
			mkdir $POST_DIR
			cp -vr target/????????-????-????-????-????????????/jmeter/bin/failed-post-requests/* $POST_DIR
		fi
		rm -vr target/????????-????-????-????-????????????
		mv $RESULT_DIR/*.csv $RESULT_DIR/test-$testNum-jtl.csv
		cp $RESULT_DIR/*.csv $TEST_DIR
		rm $RESULT_DIR/*.csv
		mv target/jmeter/logs/*.log target/jmeter/logs/test-$testNum.log
		cp target/jmeter/logs/*.log $TEST_DIR
		rm target/jmeter/logs/*.log
		mkdir $TEST_DIR/dashboard-files
		cp -r target/jmeter/reports/ppdm-test/* $TEST_DIR/dashboard-files
		rm -r target/jmeter/reports/ppdm-test/*
	done
} < src/test/jmeter/$1

rm -r target/jmeter/logs
rm -r target/jmeter/reports
rm -r target/jmeter/testFiles