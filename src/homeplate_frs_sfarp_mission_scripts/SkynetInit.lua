redIADS = SkynetIADS:create('IADS')
redIADS:addEarlyWarningRadarsByPrefix('EWR')
redIADS:addSAMSitesByPrefix('SAM')
-- redIADS:addRadioMenu() -- Uncomment for debug menu
redIADS:activate()

seadAirstartIADS = SkynetIADS:create()
seadAirstartIADS:addEarlyWarningRadarsByPrefix('SEAD-EWR')
seadAirstartIADS:addSAMSitesByPrefix('SEAD-SAM')
seadAirstartIADS:activate()
