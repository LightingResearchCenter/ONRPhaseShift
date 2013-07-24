spd = load('blue1NoNegValues.txt');
Lux = 40;
spi =(spd(:,2))*(Lux/Lxy23Sep05(spd)); % multiply only the 2nd column by the scalar
spi = [spd(:,1),spi]; % add the wavelength column back to the spd matrix
CLA = CLA_postBerlinCorrMelanopsin_02Oct2012(spi);
CS = CSCalc_postBerlin_12Aug2011(CLA)
