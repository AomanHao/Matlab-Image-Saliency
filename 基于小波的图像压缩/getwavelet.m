function [Seq,ScaleS,ScaleD,Family] = getwavelet(WaveletName)
%GETWAVELET   Get wavelet lifting scheme sequence.
% Pascal Getreuer 2005-2006

WaveletName = strrep(WaveletName,'bior','spline');
ScaleS = 1/sqrt(2);
ScaleD = 1/sqrt(2);
Family = 'Spline';

switch strrep(strrep(lower(WaveletName),'2d',''),' ','')
case {'haar','d1','db1','sym1','spline1.1','rspline1.1'}
   Seq = {1,0;-0.5,0};
   ScaleD = -sqrt(2);
   Family = 'Haar';
case {'d2','db2','sym2'}
   Seq = {sqrt(3),0;[-sqrt(3),2-sqrt(3)]/4,0;-1,1};
   ScaleS = (sqrt(3)-1)/sqrt(2);
   ScaleD = (sqrt(3)+1)/sqrt(2);
   Family = 'Daubechies';
case {'d3','db3','sym3'}
   Seq = {2.4254972439123361,0;[-0.3523876576801823,0.0793394561587384],0;
      [0.5614149091879961,-2.8953474543648969],2;-0.0197505292372931,-2};
   ScaleS = 0.4318799914853075;
   ScaleD = 2.3154580432421348;
   Family = 'Daubechies';
case {'d4','db4'}
   Seq = {0.3222758879971411,-1;[0.3001422587485443,1.1171236051605939],1;
      [-0.1176480867984784,0.0188083527262439],-1;
      [-0.6364282711906594,-2.1318167127552199],1;
      [0.0247912381571950,-0.1400392377326117,0.4690834789110281],2};   
   ScaleS = 1.3621667200737697;
   ScaleD = 0.7341245276832514;
   Family = 'Daubechies';
case {'d5','db5'}
   Seq = {0.2651451428113514,-1;[-0.2477292913288009,-0.9940591341382633],1;
      [-0.2132742982207803,0.5341246460905558],1;
      [0.7168557197126235,-0.2247352231444452],-1;
      [-0.0121321866213973,0.0775533344610336],3;0.035764924629411,-3};   
   ScaleS = 1.3101844387211246;
   ScaleD = 0.7632513182465389;
   Family = 'Daubechies';
case {'d6','db6'}
   Seq = {4.4344683000391223,0;[-0.214593449940913,0.0633131925095066],0;
      [4.4931131753641633,-9.970015617571832],2;
      [-0.0574139367993266,0.0236634936395882],-2;
      [0.6787843541162683,-2.3564970162896977],4;
      [-0.0071835631074942,0.0009911655293238],-4;-0.0941066741175849,5};   
   ScaleS = 0.3203624223883869;
   ScaleD = 3.1214647228121661;
   Family = 'Daubechies';
case 'sym4'
   Seq = {-0.3911469419700402,0;[0.3392439918649451,0.1243902829333865],0;
      [-0.1620314520393038,1.4195148522334731],1;
      -[0.1459830772565225,0.4312834159749964],1;1.049255198049293,-1};   
   ScaleS = 0.6366587855802818;
   ScaleD = 1.5707000714496564;
   Family = 'Symlet';
case 'sym5'
   Seq = {0.9259329171294208,0;-[0.1319230270282341,0.4985231842281166],1;
      [1.452118924420613,0.4293261204657586],0;
      [-0.2804023843755281,0.0948300395515551],0;
      -[0.7680659387165244,1.9589167118877153],1;0.1726400850543451,0};
   ScaleS = 0.4914339446751972;
   ScaleD = 2.0348614718930915;
   Family = 'Symlet';
case 'sym6'
   Seq = {-0.2266091476053614,0;[0.2155407618197651,-1.2670686037583443],0;
      [-4.2551584226048398,0.5047757263881194],2;
      [0.2331599353469357,0.0447459687134724],-2;
      [6.6244572505007815,-18.389000853969371],4;
      [-0.0567684937266291,0.1443950619899142],-4;-5.5119344180654508,5};
   ScaleS = -0.5985483742581210;
   ScaleD = -1.6707087396895259;
   Family = 'Symlet';
case 'coif1'
   Seq = {-4.6457513110481772,0;[0.205718913884,0.1171567416519999],0;
      [0.6076252184992341,-7.468626966435207],2;-0.0728756555332089,-2};   
   ScaleS = -0.5818609561112537;
   ScaleD = -1.7186236496830642;
   Family = 'Coiflet';
case 'coif2'
   Seq = {-2.5303036209828274,0;[0.3418203790296641,-0.2401406244344829],0;
      [15.268378737252995,3.1631993897610227],2;
      [-0.0646171619180252,0.005717132970962],-2;
      [13.59117256930759,-63.95104824798802],4;
      [-0.0018667030862775,0.0005087264425263],-4;-3.7930423341992774,5};
   ScaleS = 0.1076673102965570;
   ScaleD = 9.2878701738310099;
   Family = 'Coiflet';
case 'bcoif1'
   Seq = {0,0;-[1,1]/5,1;[5,5]/14,0;-[21,21]/100,1};
   ScaleS = sqrt(2)*7/10;
   ScaleD = sqrt(2)*5/7;
   Family = 'Nearly orthonormal Coiflet-like';
case {'lazy','spline0.0','rspline0.0','d0'}
   Seq = {0,0};
   ScaleS = 1;
   ScaleD = 1;
   Family = 'Lazy';
case {'spline0.1','rspline0.1'}
   Seq = {1,-1};
   ScaleD = 1;
case {'spline0.2','rspline0.2'}
   Seq = {[1,1]/2,0};
   ScaleD = 1;
case {'spline0.3','rspline0.3'}
   Seq = {[-1,6,3]/8,1};
   ScaleD = 1;
case {'spline0.4','rspline0.4'}
   Seq = {[-1,9,9,-1]/16,1};
   ScaleD = 1;
case {'spline0.5','rspline0.5'}
   Seq = {[3,-20,90,60,-5]/128,2};   
   ScaleD = 1;
case {'spline0.6','rspline0.6'}
   Seq = {[3,-25,150,150,-25,3]/256,2};   
   ScaleD = 1;
case {'spline0.7','rspline0.7'}
   Seq = {[-5,42,-175,700,525,-70,7]/1024,3};  
   ScaleD = 1;
case {'spline0.8','rspline0.8'}
   Seq = {[-5,49,-245,1225,1225,-245,49,-5]/2048,3};
   ScaleD = 1;
case {'spline1.0','rspline1.0'}
   Seq = {0,0;-1,0};
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);   
case {'spline1.3','rspline1.3'}
   Seq = {0,0;-1,0;[-1,8,1]/16,1};
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
case {'spline1.5','rspline1.5'}
   Seq = {0,0;-1,0;[3,-22,128,22,-3]/256,2};
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
case {'spline1.7','rspline1.7'}
   Seq = {0,0;-1,0;[-5,44,-201,1024,201,-44,5]/2048,3};   
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
case {'spline2.0','rspline2.0'}
   Seq = {0,0;-[1,1]/2,1};
   ScaleS = sqrt(2);
   ScaleD = 1;
case {'spline2.1','rspline2.1'}
   Seq = {0,0;-[1,1]/2,1;0.5,0};
   ScaleS = sqrt(2);
case {'spline2.2','rspline2.2','cdf5/3','legall5/3','s+p(2,2)','lc5/3'}
   Seq = {0,0;-[1,1]/2,1;[1,1]/4,0};
   ScaleS = sqrt(2);
case {'spline2.4','rspline2.4'}
   Seq = {0,0;-[1,1]/2,1;[-3,19,19,-3]/64,1};
   ScaleS = sqrt(2);
case {'spline2.6','rspline2.6'}
   Seq = {0,0;-[1,1]/2,1;[5,-39,162,162,-39,5]/512,2};
   ScaleS = sqrt(2);
case {'spline2.8','rspline2.8'}
   Seq = {0,0;-[1,1]/2,1;[-35,335,-1563,5359,5359,-1563,335,-35]/16384,3};
   ScaleS = sqrt(2);
case {'spline3.0','rspline3.0'}
   Seq = {-1/3,-1;-[3,9]/8,1};   
   ScaleS = 3/sqrt(2);
   ScaleD = 2/3;
case {'spline3.1','rspline3.1'}
   Seq = {-1/3,-1;-[3,9]/8,1;4/9,0};
   ScaleS = 3/sqrt(2);
   ScaleD = -2/3;
case {'spline3.3','rspline3.3'}
   Seq = {-1/3,-1;-[3,9]/8,1;[-3,16,3]/36,1};
   ScaleS = 3/sqrt(2);
   ScaleD = -2/3;
case {'spline3.5','rspline3.5'}
   Seq = {-1/3,-1;-[3,9]/8,1;[5,-34,128,34,-5]/288,2};
   ScaleS = 3/sqrt(2);
   ScaleD = -2/3;
case {'spline3.7','rspline3.7'}
   Seq = {-1/3,-1;-[3,9]/8,1;[-35,300,-1263,4096,1263,-300,35]/9216,3};
   ScaleS = 3/sqrt(2);
   ScaleD = -2/3;
case {'spline4.0','rspline4.0'}
   Seq = {-[1,1]/4,0;-[1,1],1};
   ScaleS = 4/sqrt(2);
   ScaleD = 1/sqrt(2);
   ScaleS = 1; ScaleD = 1;
case {'spline4.1','rspline4.1'}
   Seq = {-[1,1]/4,0;-[1,1],1;6/16,0};
   ScaleS = 4/sqrt(2);
   ScaleD = 1/2;
case {'spline4.2','rspline4.2'}
   Seq = {-[1,1]/4,0;-[1,1],1;[3,3]/16,0};
   ScaleS = 4/sqrt(2);
   ScaleD = 1/2;
case {'spline4.4','rspline4.4'}
   Seq = {-[1,1]/4,0;-[1,1],1;[-5,29,29,-5]/128,1};
   ScaleS = 4/sqrt(2);
   ScaleD = 1/2;
case {'spline4.6','rspline4.6'}
   Seq = {-[1,1]/4,0;-[1,1],1;[35,-265,998,998,-265,35]/4096,2};
   ScaleS = 4/sqrt(2);
   ScaleD = 1/2;
case {'spline4.8','rspline4.8'}
   Seq = {-[1,1]/4,0;-[1,1],1;[-63,595,-2687,8299,8299,-2687,595,-63]/32768,3};
   ScaleS = 4/sqrt(2);
   ScaleD = 1/2;
case {'spline5.0','rspline5.0'}
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1};   
   ScaleS = 3*sqrt(2);
   ScaleD = sqrt(2)/6;
case {'spline5.1','rspline5.1'}
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1;1/3,0};
   ScaleS = 3*sqrt(2);
   ScaleD = sqrt(2)/6;
case {'spline5.3','rspline5.3'}
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1;[-5,24,5]/72,1};
   ScaleS = 3*sqrt(2);
   ScaleD = sqrt(2)/6;
case {'spline5.5','rspline5.5'}
   Seq = {0,0;-1/5,0;-[5,15]/24,0;-[9,15]/10,1;[35,-230,768,230,-35]/2304,2};
   ScaleS = 3*sqrt(2);
   ScaleD = sqrt(2)/6;
case {'cdf9/7'}   
   Seq = {0,0;[1,1]*-1.5861343420693648,1;[1,1]*-0.0529801185718856,0;
      [1,1]*0.8829110755411875,1;[1,1]*0.4435068520511142,0};
   ScaleS = 1.1496043988602418;
   ScaleD = 1/ScaleS;
   Family = 'Cohen-Daubechies-Feauveau';
case 'v9/3'
   Seq = {0,0;[-1,-1]/2,1;[1,19,19,1]/80,1};
   ScaleS = sqrt(2);
   Family = 'HSV design';
case {'s+p(4,2)','lc9/7-m'}
   Seq = {0,0;[1,-9,-9,1]/16,2;[1,1]/4,0};   
   ScaleS = sqrt(2);
   Family = 'S+P';
case 's+p(6,2)'
   Seq = {0,0;[-3,25,-150,-150,25,-3]/256,3;[1,1]/4,0};
   ScaleS = sqrt(2);
   Family = 'S+P';
case {'s+p(4,4)','lc13/7-t'}
   Seq = {0,0;[1,-9,-9,1]/16,2;[-1,9,9,-1]/32,1};
   ScaleS = sqrt(2);
   Family = 'S+P';
case {'s+p(2+2,2)','lc5/11-c'}
   Seq = {0,0;[-1,-1]/2,1;[1,1]/4,0;-[-1,1,1,-1]/16,2};
   ScaleS = sqrt(2);
   Family = 'S+P';
case 'tt'
   Seq = {1,0;[3,-22,-128,22,-3]/256,2};
   ScaleD = sqrt(2);
   Family = 'Le Gall-Tabatabai polynomial';
case 'lc2/6'
   Seq = {0,0;-1,0;1/2,0;[-1,0,1]/4,1};
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
   Family = 'Reverse spline';
case 'lc2/10'
   Seq = {0,0;-1,0;1/2,0;[3,-22,0,22,-3]/64,2};
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
   Family = 'Reverse spline';
case 'lc5/11-a'
   Seq = {0,0;-[1,1]/2,1;[1,1]/4,0;[1,-1,-1,1]/32,2};   
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
   Family = 'Low complexity';
case 'lc6/14'
   Seq = {0,0;-1,0;[-1,8,1]/16,1;[1,-6,0,6,-1]/16,2};   
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
   Family = 'Low complexity';
case 'lc13/7-c'
   Seq = {0,0;[1,-9,-9,1]/16,2;[-1,5,5,-1]/16,1};   
   ScaleS = sqrt(2);
   ScaleD = -1/sqrt(2);
   Family = 'Low complexity';
otherwise
   Seq = {};
   return;
end

if ~isempty(findstr(lower(WaveletName),'rspline'))
   [Seq,ScaleS,ScaleD] = seqdual(Seq,ScaleS,ScaleD);
   Family = 'Reverse spline';
end

return;