# Fuzzing Webgoat

## What is Webgoat?

WebGoat is a deliberately insecure web application maintained by OWASP designed to teach
web application security lessons.

This program is a demonstration of common server-side application flaws. The exercises
are intended to be used by people to learn about application security and penetration testing techniques.

## What is fuzzing (in a nutshell)?

Fuzzing is a dynamic code analysis technique that supplies pseudo-random inputs
to a software-under-test (SUT), derives new inputs from the behaviour of the
program (i.e. how inputs are processed), and monitors the SUT for bugs.

## How can fuzzing improve web application security

As Webgoat is a Java Springboot web application, we are most interested in typical
web application vulnerabilities, such as the OWASP TOP 10. As it is written in Java, we are also concerned with
out of memories, infinite loops and logic bugs. Out of memories and infinite
loops can be exploited to achieve a denial of service of the application.

In case of Web Applications, CI Fuzz sends the fuzzing input in the form of
HTTP requests. To gather information about program execution and detect vulnerabilities/bugs,
it uses a Java agent, which inserts bytecode to the running application. This is called 
Instrumentation.

By sending unexpected inputs to the web application, fuzzing can trigger erroneous behaviour.
In case of Java applications, by leveraging instrumentation, CI Fuzz detects and reports all
unhandled exceptions, which by itself can often point developers at bugs and vulnerabilities.
There are also detectors for specific vulnerabilities, for example insecure deserialization,
SQL and LDAP injections and others.

For web application fuzzing, CI Fuzz also integrates OWASP ZAP (explained in more detail below)
to detect web application misconfigurarions and injection vulnerabilities such as SQL injection
or XSS by examining HTTP responses.

Some vulnerabilities (like some SQL injections) can be found by both methods, while others can only
be found by one of them.

## Web application fuzzing setup

The most universal example of a web application fuzz test is the "all_endpoints" fuzz test.
By dynamically analysing Springboot endpoints, CI Fuzz has created files with HTTP requests in

[`.code-intelligence/all_endpoints_seed_corpus`](https://github.com/ci-fuzz/webgoat/blob/out_of_process_fuzzing/.code-intelligence/all_endpoints_seed_corpus).

These will be used as starting point for CI Fuzz, which will then generate new requests by introducing random changes.
If you explore these request files, you may notice that POST requests have empty bodies. CI Fuzz will fill those
automatically, based on data collected during the analysis of Springboot endpoints. However, it is also possible to
fill them manually, which is worthwile if for example certain known strings in some fields result in different
program execution, but cannot be automatically discovered by analysing the endpoints.

## A note regarding corpus data

For each fuzz test, a corpus of interesting inputs is built up.
Over time, the fuzzer will add more and more inputs to this corpus, based on
coverage metrics such as newly-covered lines, statements or even values in an
expression. The genetic algorithm is used to generate new inputs based on the
current corpus.

## Corpus and OWASP ZAP integration

CI Fuzz runs OWASP ZAP active scan on all corpus inputs and reports OWASP ZAP findings alongside other findings.

## Authenticated fuzzing

In order to cover the web application properly, the fuzzer must authenticate to it.
The easiest way to do this is using the initial requests file script:
[`.code-intelligence/fuzz_targets/all_endpoints_initial_requests.http`](https://github.com/ci-fuzz/webgoat/blob/master/.code-intelligence/fuzz_targets/all_endpoints_initial_requests.http).

The cookies received in a response to these requests will be added to the HTTP
headers of all requests sent by CI Fuzz when running the all_endpoints fuzz test.

We are sending both the request that creates a user and the login request, so that
we don't have to rely on this user existing or not existing when fuzzing starts.

## Fuzzing in CI/CD

CI Fuzz allows you to configure your pipeline to automatically trigger the run of fuzz tests.
Most of the fuzzing runs that you can inspect here were triggered automatically (e.g. by pull or merge request on the GitHub project).
As you can see in this [`pull request`](https://github.com/ci-fuzz/webgoat/pull/10) the fuzzing results are automatically commented by the github-action and developers
can consume the results by clicking on "View Finding" which will lead them directly to the bug description with all the details
that CI Fuzz provides (input that caused the bug, stack trace, bug location).
With this configuration comes the hidden strength of fuzzing into play:  
Fuzzing is not like a penetration test where your application will be tested one time only.
Once you have configured your fuzz test it can help you for the whole rest of your developing cycle.
By running your fuzz test each time when some changes where made to the source code you can quickly check for
regressions and also quickly identify new introduced bugs that would otherwise turn up possibly months 
later during a penetration test or (even worse) in production. This can help to significantly reduce the bug ramp down phase of any project.

While these demo projects are configured to trigger fuzzing runs on merge or pull requests
there are many other configuration options for integrating fuzz testing into your CI/CD pipeline
for example you could also configure your CI/CD to run nightly fuzz tests.
 


