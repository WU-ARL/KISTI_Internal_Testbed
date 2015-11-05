# KISTI_Internal_Testbed
Test a topology for inter-domain routing between the NDN Testbed and an Internal testbed at KISTI.

Topology file for loading into the ONL RLI is in ONL_RLI_Files/KISTI...

If you ever change either of these two files in the configuration directory: routers.with_costs, template.conf
then you will to re-generate the NLSR configuration files.
To do that do this:
> cd configuration/NLSR_CONF
> python setup_conf_with_costs.py

Then you need to load the topology into the RLI, make a reservation and commit.

Once the commit is completed you are ready to start the daemons.
To do that run this:
> cd configuration
> ./runAll.sh





