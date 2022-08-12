# **JMeter PPDM**: An Automated Testing Framework
JMeter PPDM is a performance testing tool for APIs. The tool adds a command line script to Apache JMeter to improve its automation capabilities.

## Quickstart
To run JMeter PPDM, open a bash terminal and run the jmeter-runner.sh script. The script takes one argument: the name of .csv config file, which should be located inside of src/test/jmeter/data. As an example, try using **test-config.csv**. Basic response time metrics (min, max, avg) and the number of successful and unsuccessful requests will be displayed inside the terminal. The script also creates a **/test-results/** folder inside of **/data/** after deleting any existing folder. This folder contains a .jtl file that logs the results of all requests.

## Project Contents
- **jmeter-runner.sh**: Bash script for running JMeter PPDM. The script takes one parameter: a .csv config file. It runs "mvn clean" once followed by "mvn install <specified parameters>" for each test in the file.
- **pom.xml**: A POM file for running the project with Maven.
- **/src/test/jmeter/bin/**: Contains all of the executables needed to run JMeter and JMeter PPDM.
    - **ppdm-test.jmx**: Default JMeter test file, which is designed to run with parameters passed from **test-config.csv**.
    - **jmeter.bat**: Starts the JMeter in GUI mode. Use for editing and writing tests, *NOT* running tests.
    - **user.properties**: Configures JMeter properties, notably chart granularity.
- **src/test/jmeter/data/**: Contains files for configuration and results.
    - **.-config.csv**: Configuration files for JMeter PPDM. Must contain the following parameters (with headers): 
        - *testNum*: Index of test. MUST be unique for results to be logged properly.
        - *IP*: IP of machine. 
        Ex: 10.235.46.217
        - *port*: Port of API on machine. 
        Ex: 8580
        - *URI*: Specific path for given endpoint.
        - *username*: Username to get token from {IP}:8443/api/v2/login; cannot be used to login elsewhere.
        - *password*: Password to get token from {IP}:8443/api/v2/login; cannot be used to login elsewhere.
        - *verb*: GET or POST, depending on request type.
        - *bodyFile*: File name of POST body template.
        - *dependencies*: Used to create POST bodies with foreign keys. If there are no dependencies, fill this field with "NA". Dependencies have three components separated by a : delimiter: a "URI", a "fileName", and a "fieldName". Dependencies are separated from one another by a ~ delimiter. When a dependency is specified, JMeter will make a POST request to the specified "URI" at startup. The POST request will use "fileName" to determine what POST body template to use for the request. The test will place the ID from the response into the "fieldName", which should correspond to a placeholder in the *bodyFile* POST template.
            - Example: /api/v3/infrastructure-objects:application-host-template:hostID~/api/v3/infrastructure-objects:application-host-template-2 would trigger a POST request for the creation of two "Application Host" objects. They would be created using two different templates stored inside **/data/**. The IDs of each response would be inserted in place of the respective fieldName (like "${__P(hostID)}") in the *bodyFile* when the regular POST request is sent.
        - *numDependencies*: Number of dependencies separated by ~ delimiter in previous field.
        - *numThreads*: Number of concurrent threads started by JMeter.
        - *requestsPerThread*: Number of loops performed by each thread; total number of threads is *numThreads* * *requestsPerThread*.
        - *rampUpTime*: Amount of seconds for all threads to start. Threads are started at a constant rate; 100 threads and 10 seconds means that 10 threads will be added per second. Set to 0 to eliminate this behavior.
    - **.-template.json**: POST body templates for POST requests. Used for the *bodyFile* and *dependencies* fields. These templates take hardcoded JMeter parameters that will be dynamically interpreted, like "${__UUID()}". In addition, property syntax can be used to fill in foreign keys (see *dependencies* for more information).
- **/target/jmeter/test-results/**: Contains a directory for each test specified in **test-config.csv**. Each test results directory contains a .jtl file logging every request and a /failed-post-bodies/ directory if applicable.

## Warnings
- **jmeter-runner.sh** will not run properly if any files inside **/test-results/** are currently open.
- JMeter's GUI mode is *NOT* recommended for running tests, as an active GUI compromises performance. By the same token, JMeter's command line mode is *NOT* recommended for writing tests. In general, GUI mode is to be used for writing tests and command line mode is to be used for running tests.
- At a certain number of threads (around 2000 for GET requests), JMeter will start to throw exceptions on some requests. This is because Java has a built-in socket timeout that limits the amount of threads that can be active at one time.

## Credits
This tool was developed by **Yuxin Huang**, **Joshua Jerome**, **Kevin Kodama**, and **Edward Xia** under the supervision of **Hadi Abdo**, **Prabhash Krishnan**, and **Thao Pham**. All rights to this project belong to **Dell Technologies**.