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
    
*** Keywords ***
Test Setup
    Open Browser                http://localhost:7001/basicwebapp
Test Close
    Close Browser

*** Variables ***




