redIADS = SkynetIADS:create('IADS')
redIADS:addEarlyWarningRadarsByPrefix('EWR')
redIADS:addSAMSitesByPrefix('SAM')
-- redIADS:addRadioMenu() -- Uncomment for debug menu