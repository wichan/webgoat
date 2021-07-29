# Fuzzing Webgoat

## What is Webgoat?

WebGoat is a deliberately insecure web application maintained by OWASP designed to teach web application security lessons.

This program is a demonstration of common server-side application flaws. The exercises are intended to be used by people to learn about application security and penetration testing techniques.

## What is fuzzing (in a nutshell)?

Fuzzing is a dynamic code analysis technique that supplies pseudo-random inputs
to a software-under-test (SUT), derives new inputs from the behaviour of the
program (i.e. how inputs are processed), and monitors the SUT for bugs.

As Webgoat is a Java Springboot Web Application, we are most interested in typical
Web Application vulnerabilities, such as the OWASP TOP 10.

## Fuzzing web applications

In case of Web Applications, CI Fuzz sends the fuzzing input in the form of
HTTP requests. To gather information about program execution and detect vulnerabilities/bugs,
it uses a Java agent, which inserts bytecode to the running application. This is called 
Instrumentation.

The most universal example of this type of a web application fuzz test is the "all_endpoints" fuzz test.
By dynamically analysing Springboot endpoints, CI Fuzz has created files with HTTP requests in the

[`.code-intelligence/all_endpoints_seed_corpus`](https://github.com/ci-fuzz/webgoat/blob/out_of_process_fuzzing/.code-intelligence/all_endpoints_seed_corpus).

These will be used as starting point for CI Fuzz, which will then generate new requests by introducing random changes.
If you explore these request files, you may notice that POST requests have empty bodies. CI Fuzz will fill those
automatically, based on data collected during the analysis of Springboot endpoints. However, it is also possible to
fill them manually, which is worthwile if for example certain known strings in some fields result in different
program execution, but cannot be automatically discovered by analysing the endpoints.

## A note regarding corpus data (and why there are more fuzz tests to explore)

For each fuzz test, a corpus of interesting inputs is built up.
Over time, the fuzzer will add more and more inputs to this corpus, based on
coverage metrics such as newly-covered lines, statements or even values in an
expression.


