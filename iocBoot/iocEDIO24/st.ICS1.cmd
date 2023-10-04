#!../../bin/linux-x86_64/measCompApp

< envPaths

# Set server port
epicsEnvSet("EPICS_CA_SERVER_PORT", "63101")

# Shell prompt
epicsEnvSet("IOCSH_PS1", "sioc-ics1-lc01> ")

# devIocStats
epicsEnvSet("DEVIOCSTATS", "$(SUPPORT)/iocStats-3-1-16")

## Register all support components
dbLoadDatabase "$(MEASCOMP)/dbd/measCompApp.dbd"
measCompApp_registerRecordDeviceDriver pdbbase

epicsEnvSet("PREFIX",        "LED:ICS1:")
epicsEnvSet("PORT",          "EDIO24_1")
epicsEnvSet("UNIQUE_ID",     "10.139.0.224")

## Configure port driver
# MultiFunctionConfig((portName,        # The name to give to this asyn port driver
#                      uniqueID,        # For USB the serial number.  For Ethernet the MAC address or IP address.
#                      maxInputPoints,  # Maximum number of input points for waveform digitizer
#                      maxOutputPoints) # Maximum number of output points for waveform generator
MultiFunctionConfig("$(PORT)", "$(UNIQUE_ID)", 1, 1)

#asynSetTraceMask($(PORT), -1, ERROR|FLOW|DRIVER)

dbLoadTemplate("$(MEASCOMP)/db/EDIO24.substitutions", "P=$(PREFIX),PORT=$(PORT)")

dbLoadTemplate("$(MEASCOMP)/iocBoot/$(IOC)/ICS1.substitutions", "P=$(PREFIX),Bo=Bo, Bi=Bi")

# devIocStats
#dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db","IOC=SIOC:ICS1:LC01")

< ../save_restore.cmd
set_savefile_path("./autosave/ics1-mp10")

iocInit

create_monitor_set("auto_settings.req",30,"P=$(PREFIX)")
