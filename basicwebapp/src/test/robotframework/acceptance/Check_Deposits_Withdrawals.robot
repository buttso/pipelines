*** Settings ***
Documentation   Acceptance testing
Library         Selenium2Library

*** Test Cases ***     
Make 2x$100 deposits and check balance is correct
    Open Browser                http://localhost:7001/basicwebapp
    Page Should Contain         Please Enter Your Account Name and Amount
    Page Should Contain Textfield   j_idt10:name
    Page Should Contain Textfield   j_idt10:amount
    Page Should Contain Button      j_idt10:j_idt18
    Input Text                      j_idt10:name    Barney
    Input Text                      j_idt10:amount  100
    Click Button                    j_idt10:j_idt18
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is 100.0       
    Input Text                      j_idt10:name    Barney
    Input Text                      j_idt10:amount  100
    Click Button                    j_idt10:j_idt18
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is 200.0           
    Close Browser
Make 2x$100 deposits and a 1x$200 withdrawal and check balance is correct
    Open Browser                http://localhost:7001/basicwebapp
    Page Should Contain         Please Enter Your Account Name and Amount
    Page Should Contain Textfield   j_idt10:name
    Page Should Contain Textfield   j_idt10:amount
    Page Should Contain Button      j_idt10:j_idt18
    Input Text                      j_idt10:name    Barney
    Input Text                      j_idt10:amount  100
    Click Button                    j_idt10:j_idt18
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is 100.0       
    Input Text                      j_idt10:name    Barney
    Input Text                      j_idt10:amount  100
    Click Button                    j_idt10:j_idt18
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is 200.0           
    Input Text                      j_idt10:name    Barney
    Input Text                      j_idt10:amount  -200
    Click Button                    j_idt10:j_idt18
    Wait Until Page Contains    The money have been deposited to Barney, the balance of the account is 0.0
    Close Browser
    
*** Keywords ***
Test Setup
    Open Browser                http://localhost:7001/basicwebapp
Test Close
    Close Browser

*** Variables ***




