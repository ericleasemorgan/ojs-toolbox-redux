# OJS Toolbox Redux

Given a list of journals published using OJS, cache (acquisition) the whole of the journals. And since this is the briefest of documentation, all the magic happens in [./bin/build.sh](./bin/build.sh). You will need a few thing to make this system go: Bash, Perl (specifically, a module named Net::OAI::Harvester), SQLite, and GNU Parallel. --Eric Lease Morgan &lt;<a href="mailto:emorgan@nd.edu">emorgan@nd.edu</a>&gt; (October 28, 2022)
