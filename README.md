# pipelines

Steve Button   
Feb 2015

This project contains an end-to-end example of testing an application that is deployed to WebLogic and then unit tested using Arquillian and acceptance tested using the Robot Framework.  

## Testing Plugins

This project uses multiple Maven plugins and other frameworks to perform the different tasks required to execute tests of the application for both developer oriented unit testing as well as higher level acceptance testing.

### WebLogic Maven Plugin

The **WebLogic Maven Plugin** is used to perform all of the tasks associated with WebLogic: 

+ Installing the server;
+ Creating a domain;
+ Startinf the server;
+ Deploying the application;
+ Undeploying the application;
+ Stopping the server;
+ Removing the domain;

```
<plugin>
    <groupId>com.oracle.weblogic</groupId> 
    <artifactId>weblogic-maven-plugin</artifactId> 
    <version>12.1.3-0-0</version> 
    <configuration> 
        <domainHome>${oracleHome}/dev-domain</domainHome>
        <failOnDomainExists>false</failOnDomainExists>
    </configuration>
    <executions>
        <!--Install WebLogic -->
        <execution>
            <id>install-weblogic</id>
            <phase>initialize</phase> 
            <goals> 
                <goal>install</goal> 
            </goals>
        </execution> 
        <!-- Create the test domain -->
        <execution>
            <id>create-weblogic-domain</id>
            <phase>initialize</phase> 
            <goals> 
                <goal>create-domain</goal> 
            </goals>
        </execution> 
    </executions>
</plugin>
```

### Arquillian Container Adapter

The **Arquillian** testing framework is used to execute unit tests on the application code and performs the following tasks:

+ ShrinkWrap API - programmatically create an archive to deploy;
+ Arquillian JUnit - execute a unit test including conducting the packaging and deployment operation and executing the unit test inside the container;
+ Arquillian WebLogic Managed Container Adapter  - start a local WebLogic Server instance, deploy the application in its test form;
+ The WebLogic Maven Plugin is used to perform the installation and domain creation;

**Maven Configuration**

```
<project>
    ...
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.jboss.arquillian</groupId>
                <artifactId>arquillian-bom</artifactId>
                <version>1.1.5.Final</version>
                <scope>import</scope>
                <type>pom</type>
            </dependency>
        </dependencies>
    </dependencyManagement>  
    ...
    <dependencies>
        <!-- Specify the JUnit container for Arquillian to use -->
        <dependency>
            <groupId>org.jboss.arquillian.junit</groupId>
            <artifactId>arquillian-junit-container</artifactId>
            <scope>test</scope>
        </dependency>
        ...
        <!-- Specify the Container Adapter to use -->
        <dependency>
            <groupId>org.jboss.arquillian.container</groupId>
            <artifactId>arquillian-wls-managed-12.1.2</artifactId>
            <version>1.0.0.Alpha3</version>
            <scope>test</scope>
        </dependency>          
        ...
        
    </dependencies>
    ...
</project>
```
**Unit Test**

```
package buttso.demo.weblogic.maven;

import com.bea.core.repackaged.springframework.util.Assert;
import javax.inject.Inject;
import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.EmptyAsset;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.junit.Test;
import org.junit.runner.RunWith;

/**
 *
 * Simple test case to verify behavior of EJB component
 * Uses @Inject to inject bean to test
 *
 */
@RunWith(Arquillian.class)
public class AccountBeanTest {

    @Inject
    AccountBean accountBean;
       
    @Deployment
    public static JavaArchive createDeployment() {
        JavaArchive jar = ShrinkWrap.create(JavaArchive.class)
                .addClass(AccountBean.class)
                .addAsManifestResource(EmptyAsset.INSTANCE, "beans.xml");
        System.out.println(jar.toString(true));
        return jar;
    }

    @Test
    
    public void test_account_bean   () {
        String name = "Jack";
        Float amount = 100.99F;
        Assert.notNull(accountBean, "AccountBean was not injected, is null");
        accountBean.setName(name);
        accountBean.setAmount(amount);
        accountBean.deposit();
        String message = accountBean.getMsg();
        Assert.isTrue(amount == accountBean.getAmount(), accountBean.getName() + " should have " + amount + " but has $" + accountBean.getAmount());
    }
}

```

### Robot Framework
The **Robot Framework Maven Plugin** is used to perform acceptance testing of the application by using the user interface to perform tasks and verifying the results are as expected.  The Robot Framework Maven Plugin is used to run the Robot tests:

+ Parse the acceptance test;
+ Use the Selenium2 library to drive the user interface with the specified inputs;
+ Verify the results of the page match what is expected;
+ Report results;

```
<project>
    ...
    <plugins>
        ...
        <!--  Robot Framework Maven Plugin -->
        <plugin>
            <groupId>org.robotframework</groupId>
            <artifactId>robotframework-maven-plugin</artifactId>
            <version>1.4.4</version>
            <executions>
                <execution>
                    <id>robot-test</id>
                    <phase>integration-test</phase>
                    <goals>
                        <goal>acceptance-test</goal>
                    </goals>
                    <configuration>
                        <skipITs>false</skipITs>
                        <skipATs>false</skipATs>
                        <skipTests>false</skipTests>
                    </configuration>
                </execution>
            </executions>
        </plugin>                    
    <plugins>
</project>

```

**Robot Test Script**

```
*** Settings ***
Documentation   Acceptance testing
Library         Selenium2Library

*** Test Cases ***     
Make 2x$100 deposits and check balance is correct
    Open Browser                http://localhost:7001/basicwebapp
    Page Should Contain         Please Enter Your Account Name and Amount
    Page Should Contain Textfield   deposit_form:name
    Page Should Contain Textfield   deposit_form:amount
    Page Should Contain Button      deposit_form:deposit
    Input Text                      deposit_form:name    Barney
    Input Text                      deposit_form:amount  100
    Click Button                    deposit_form:deposit
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is $100.00       
    Input Text                      deposit_form:name    Barney
    Input Text                      deposit_form:amount  100
    Click Button                    deposit_form:deposit
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is $200.00           
    Close Browser
Make 2x$100 deposits and a 1x$200 withdrawal and check balance is correct
    Open Browser                http://localhost:7001/basicwebapp
    Page Should Contain         Please Enter Your Account Name and Amount
    Page Should Contain Textfield   deposit_form:name
    Page Should Contain Textfield   deposit_form:amount
    Page Should Contain Button      deposit_form:deposit
    Input Text                      deposit_form:name    Barney
    Input Text                      deposit_form:amount  100
    Click Button                    deposit_form:deposit
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is $100.00       
    Input Text                      deposit_form:name    Barney
    Input Text                      deposit_form:amount  100
    Click Button                    deposit_form:deposit
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is $200.00           
    Input Text                      deposit_form:name    Barney
    Input Text                      deposit_form:amount  -200
    Click Button                    deposit_form:deposit
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is $0.00
    Close Browser
```

## Exececuting Tests
### WebLogic-DEV

```
[sbutton] basicwebapp $ mvn -q -P weblogic-DEV

-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running buttso.demo.weblogic.maven.AccountBeanTest
Feb 23, 2015 2:53:41 PM org.jboss.arquillian.container.wls.WebLogicServerControl$StartupAdminServerCommand execute
INFO: Started WebLogic Server.
b2ee4ceb-e140-4c89-8778-c47f5eedfb95.jar:
/buttso/
/buttso/demo/
/buttso/demo/weblogic/
/buttso/demo/weblogic/maven/
/buttso/demo/weblogic/maven/AccountBean.class
/META-INF/
/META-INF/beans.xml
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 9.82 sec
Feb 23, 2015 2:53:51 PM org.jboss.arquillian.container.wls.WebLogicServerControl$ShutdownAdminServerCommand execute
INFO: Stopped WebLogic Server.

Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
```
### WebLogic-AT

```
[sbutton@dhcp-au-adelaide-10-187-112-202] basicwebapp $ mvn -q -P weblogic-AT
.......
weblogic.Deployer invoked with options:  -noexit -deploy -user weblogic -name basicwebapp -source /private/tmp/pipelines/basicwebapp/target/basicwebapp.war -targets AdminServer -verbose -adminurl t3://localhost:7001
<23/02/2015 2:55:20 PM CST> <Info> <J2EE Deployment SPI> <BEA-260121> <Initiating deploy operation for application, basicwebapp [archive: /private/tmp/pipelines/basicwebapp/target/basicwebapp.war], to AdminServer .> 
Task 0 initiated: [Deployer:149026]deploy application basicwebapp on AdminServer.
Task 0 completed: [Deployer:149026]deploy application basicwebapp on AdminServer.
Target state: deploy completed on Server AdminServer

Target Assignments:
+ basicwebapp  AdminServer
==============================================================================
Acceptance                                                                    
==============================================================================
Acceptance.Check Deposits Withdrawals :: Acceptance testing                   
==============================================================================
Make 2x$100 deposits and check balance is correct                     | PASS |
------------------------------------------------------------------------------
Make 2x$100 deposits and a 1x$200 withdrawal and check balance is ... | PASS |
------------------------------------------------------------------------------
Acceptance.Check Deposits Withdrawals :: Acceptance testing           | PASS |
2 critical tests, 2 passed, 0 failed
2 tests total, 2 passed, 0 failed
==============================================================================
Acceptance                                                            | PASS |
2 critical tests, 2 passed, 0 failed
2 tests total, 2 passed, 0 failed
==============================================================================
Output:  /private/tmp/pipelines/basicwebapp/target/robotframework-reports/output.xml
XUnit:   /private/tmp/pipelines/basicwebapp/target/robotframework-reports/TEST-acceptance.xml
Log:     /private/tmp/pipelines/basicwebapp/target/robotframework-reports/log.html
Report:  /private/tmp/pipelines/basicwebapp/target/robotframework-reports/report.html
```






