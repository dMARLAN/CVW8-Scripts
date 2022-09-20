redIADS = SkynetIADS:create('IADS')
redIADS:addEarlyWarningRadarsByPrefix('EWR')
redIADS:addSAMSitesByPrefix('SAM')

seadAirstartIADS = SkynetIADS:create()
seadAirstartIADS:addEarlyWarningRadarsByPrefix('SEAD-EWR')
seadAirstartIADS:addSAMSitesByPrefix('SEAD-SAM')
-- redIADS:addRadioMenu() -- Uncomment for debug menu