* APO Project GAMS file

set
i        groups / asCH3, asCH2as, asasCHas, asasCasas, adCH2, adCHas, adCasas, adCad, tCH, tCas,
                  csCH2cs, cscsCHcs, cscsCcscs, cdCHcs, cdCcscs,asF, asCl, asBr, asI, asOH, csOH,
                  asOas, csOcs, asasCO, cscsCO, OCHas, asCOOH, asCOOas, adO, asNH2, asasNH, cscsNH,
                  asasNas, asNad, csNcd, adNH, asCN, asNO2, asSH, asSas, csScs /

j        index for group definitions             / a, b, Yas, Yad, Yt, Ycs, Ycd /
o        index for heat capacity contributions   / A, B, C, D /
p        index for group contribution methods    / Tb, Hvb, Tc, Pc /

bin      binary index / bin1 * bin4 /
c        integer cuts / 1 * 10 /
dyn(c)   dynamic set of c
;


parameters
Tevap            evaporating temperature [k]
Tcond            condensing temperature [k]
Tavg             average porcess temperature [k]
HveR             heat of vaporisation of R134a (at evaporating temperature) [KJ*mol-1]
CplaR            liquid heat capacity of R134a (at average operating temperature) [KJ*mol-1]
Nmax             maximum amount of groups
nL(i)            groups lower bounds
nU(i)            groups upper bounds
Kmax             maximum binary factor

yv(i, bin, c)    store y values from previous solutions
nv(i, c)         store n values
OFv(c)           store OF values
Cplav(c)         store Cpla values
Hvev(c)          store Hve values
;

Tevap = 272;
Tcond = 316;
Tavg = 294;
HveR = 20.322;
CplaR = 143.915;
Nmax = 7;
nL(i) = 0;
nU(i) = 3;
Kmax = smax(i, ceil(log(nU(i) - nL(i)) / log(2)));


Table GD(i, j)
                 a       b       Yas     Yad     Yt      Ycs     Ycd
asCH3            4       1       1
asCH2as          3       2       2
asasCHas         2       3       3
asasCasas        1       4       4
adCH2            3       1               1
adCHas           2       2       1       1
adCasas          1       3       2       1
adCad            1       2               2
tCH              2       1                       1
tCas             1       2       1               1
csCH2cs          3       2                               2
cscsCHcs         2       3                               3
cscsCcscs        1       4                               4
cdCHcs           2       2                               1       1
cdCcscs          1       3                               2       1
asF              1       1       1
asCl             1       1       1
asBr             1       1       1
asI              1       1       1
asOH             2       1       1
csOH             2       1                               1
asOas            1       2       2
csOcs            1       2                               2
asasCO           2       2       2
cscsCO           2       2                               2
OCHas            3       1       1
asCOOH           4       1       1
asCOOas          3       2       2
adO              1       1               1
asNH2            3       1       1
asasNH           2       2       2
cscsNH           2       2                               2
asasNas          1       3       3
asNad            1       2       1       1
csNcd            1       2                               1       1
adNH             2       1               1
asCN             2       1       1
asNO2            3       1       1
asSH             2       1       1
asSas            1       2       2
csScs            1       2                               2
;

Table Cpo(i, o)
                 A               B               C               D
asCH3            1.95E+1         -8.08E-3        1.53E-4         -9.67E-8
asCH2as          -9.09E-1        9.50E-2         -5.44E-5        1.19E-8
asasCHas         -2.30E+1        2.04E-1         -2.65E-4        1.20E-7
asasCasas        -6.62E+1        4.27E-1         -6.41E-4        3.01E-7
adCH2            2.36E+1         -3.81E-2        1.72E-4         -1.03E-7
adCHas           -8.00           1.05E-1         -9.63E-5        3.56E-8
adCasas          -2.81E+1        2.08E-1         -3.06E-4        1.46E-7
adCad            2.74E+1         -5.57E-2        1.01E-4        -5.02E-8
tCH              2.45E+1         -2.71E-2        1.11E-4         -6.78E-8
tCas             7.87            2.01E-2         -8.33E-6        1.39E-9
csCH2cs          -6.03           8.54E-2         -8.00E-6        -1.80E-8
cscsCHcs         -2.05E+1        1.62E-1         -1.60E-4        6.24E-8
cscsCcscs        -9.09E+1        5.57E-1         -9.00E-4        4.69E-7
cdCHcs           -2.14           5.74E-2         -1.64E-6        -1.59E-8
cdCcscs          -8.25           1.01E-1         -1.42E-4        6.78E-8
asF              2.65E+01        -9.13E-02       1.91E-04        -1.03E-07
asCl             3.33E+01        -9.63E-02       1.87E-04        -9.96E-08
asBr             2.86E+01        -6.49E-02       1.36E-04        -7.45E-08
asI              3.21E+01        -6.41E-02       1.26E-04        -6.87E-08
asOH             2.57E+01        -6.91E-02       1.77E-04        -9.88E-08
csOH             -2.81           1.11E-01        -1.16E-04       4.94E-08
asOas            2.55E+01        -6.32E-02       1.11E-04        -5.48E-08
csOcs            1.22E+01        -1.26E-02       6.03E-05        -3.86E-08
asasCO           6.45            6.70E-02        -3.57E-05       2.86E-09
cscsCO           3.04E+01        -8.29E-02       2.36E-04        -1.31E-07
OCHas            3.09E+01        -3.36E-02       1.60E-04        -9.88E-08
asCOOH           2.41E+01        4.27E-02        8.04E-05        -6.87E-08
asCOOas          2.45E+01        4.02E-02        4.02E-05        -4.52E-08
adO              6.82            1.96E-02        1.27E-05        -1.78E-08
asNH2            2.69E+01        -4.12E-02       1.64E-04        -9.76E-08
asasNH           -1.21           7.62E-02        -4.86E-05       1.05E-08
cscsNH           1.18E+01        -2.30E-02       1.07E-04        -6.28E-08
asasNas          -3.11E+01       2.27E-01        -3.20E-04       1.46E-07
asNad
csNcd            8.83            -3.84E-03       4.35E-05        -2.60E-08
adNH             5.69            -4.12E-03       1.28E-04        -8.88E-08
asCN             3.65E+01        -7.33E-02       1.84E-04        -1.03E-07
asNO2            2.59E+01        -3.74E-03       1.29E-04        -8.88E-08
asSH             3.53E+01        -7.58E-02       1.85E-04        -1.03E-07
asSas            1.96E+01        -5.61E-03       4.02E-05        -2.76E-08
csScs            1.67E+01        4.81E-03        2.77E-05        -2.11E-08
;

Table GC(i, p)
                 Tb              Hvb             Tc              Pc
asCH3            23.58           2.373           0.0141          -0.0012
asCH2as          22.88           2.226            0.0189         0
asasCHas         21.74           1.691           0.0164          0.002
asasCasas        18.25           0.636           0.0067          0.0043
adCH2            18.18           1.724           0.0113          -0.0028
adCHas           24.96           2.205           0.0129          -0.0006
adCasas          24.14           2.138           0.0117          0.0011
adCad            26.15           2.661           0.0026          0.0028
tCH              9.2             1.155           0.0027          -0.0008
tCas             27.38           3.302           0.002           0.0016
csCH2cs          27.15           2.398           0.01            0.0025
cscsCHcs         21.78           1.942           0.0122          0.0004
cscsCcscs        21.32           0.644           0.0042          0.0061
cdCHcs           26.73           2.544           0.0082          0.0011
cdCcscs          31.01           3.059           0.0143          0.0008
asF              -0.03           -0.67           0.0111          -0.0057
asCl             38.13           4.532           0.0105          -0.0049
asBr             66.86           6.582           0.0133          0.0057
asI              93.84           9.52            0.0068          -0.0034
asOH             92.88           16.826          0.0741          0.0112
csOH             76.34           12.499          0.024           0.0184
asOas            22.42           2.41            0.0168          0.0015
csOcs            31.22           4.682           0.0098          0.0048
asasCO           76.75           8.972           0.038           0.0031
cscsCO           94.97           6.645           0.0284          0.0028
OCHas            72.24           9.093           0.0379          0.003
asCOOH           169.09          19.537          0.0791          0.0077
asCOOas          81.1            9.633           0.0481          0.0005
adO              -10.5           5.909           0.0143          0.0101
asNH2            73.23           10.788          0.0243          0.0109
asasNH           50.17           6.436           0.0295          0.0077
cscsNH           52.82           6.93            0.013           0.0114
asasNas          11.74           1.896           0.0169          0.0074
asNad            74.6            3.335           0.0255          -0.0099
csNcd            57.55           6.528           0.0085          0.0076
adNH             83.08           12.169
asCN             125.66          12.851          0.0496          -0.0101
asNO2            152.54          16.738          0.0437          0.0064
asSH             63.56           6.884           0.0031          0.0084
asSas            68.78           6.817           0.0119          0.0049
csScs            52.1            5.984           0.0019          0.0051
;

variables
OF       objective value

n(i)             molecular groups
y(i, bin)        binary auxiliar variable

Pve      vapour pressure (at evaporating temperature) [bar]
Pvc      vapour pressure (at condensing temperature) [bar]
Hve      heat of vaporisation (at evaporating temperature) [KJ*mol-1]
Cpla     liquid heat capacity (at average operating temperature) [KJ*mol-1]
Hvb      heat of vaporisation (at boiling temperature) [KJ*mol-1]
Tb       boiling temperature [k]
Tc       critical temperature [k]
Tbr      reduced boiling temperature [k]
Tevapr   reduced evaporating temperature [k]
Pc       critical pressure [bar]
Cpoa     ideal gas heat capacity (at average temperature) [J*mol-1*K-1]
alpha    intermediate variable to find acentric factor
beta     intermediate variable to find acentric factor
omega    acentric factor
Tavgr    reduced average process temperature [k]
Tcondr   reduced condensing temperature [k]
h        intermediate variable to find vapour pressure
G        intermediate variable to find vapour pressure
k        intermediate variable to find vapour pressure
Pver     reduced vapour pressure (at evaporating temperature)
Pvcr     reduced vapour pressure (at condensing temperature)
YA       1 if only acyclic bonds are present
YC       1 if only cyclic bonds are present
YM       1 if both cyclic and acyclic bonds are present
YR       1 if groups with cyclic bonds are selected
YSDx     1 if both single and double bonds are present
YSDy     1 if only single bonds are present
YSDz     1 if only double bonds are present
YSTx     1 if both single and triple bonds are present
YSTy     1 if only single bonds are present
YSTz     1 if only triple bonds are present
l        variable to define number of single bonded groups
u        variable to define number of single bonded groups
ZB       auxiliar variable for uneven amount of bonds definition
ZS       auxiliar variable for acyclic single bonded definition
ZSR      auxiliar variable for cyclic single bonded definition
ZD       auxiliar variable for acyclic double bonded definition
ZDR      auxiliar variable for cyclic double bonded definition
ZT       auxiliar variable for triple bonded definition
m        1 for acyclic and = 0 for monocyclic and -1 for bicyclic
YH       binary variable to monitor the selection of higher-bonded groups
;

positive variables
Cpla, Tb, Tc, Tbr, Tevapr, Pc, Cpoa, omega, Tavgr, Tcondr
;

binary variables
y(i, bin), YA, YC, YM, YR, YSDx, YSDy, YSDz, YSTx, YSTy, YSTz, YH
;

integer variables
n(i), ZB, ZS, ZSR, ZD, ZDR, ZT, m
;


***    Initial 'conditions'    ***
n.l('asCH3') = 1 ;
n.l('asSH') = 1;

y.l('asCH3', 'bin1') = 1;
y.l('asSH', 'bin1') = 1;

Hvb.l = 15.3 + sum(i, n.l(i) * GC(i, 'Hvb'));
Tb.l = 198.2 + sum(i, n.l(i) * GC(i, 'Tb'));
Tc.l = Tb.l / (0.584 + 0.965 * sum(i, n.l(i) * GC(i, 'Tc')) - (sum(i, n.l(i) * GC(i, 'Tc'))) ** 2);
Tbr.l = Tb.l / Tc.l;
Tevapr.l = Tevap / Tc.l;
Hve.l = Hvb.l * ((1 - Tevapr.l) / (1 - Tbr.l)) ** 0.38;

Cpoa.l = (sum(i, n.l(i) * Cpo(i, 'A')) - 37.93 + (sum(i, n.l(i) * Cpo(i, 'B')) + 0.21) * Tavg + (sum(i, n.l(i) * Cpo(i, 'C')) - 3.91 * 10 ** (- 4)) * (Tavg ** 2) + (sum(i, n.l(i) * Cpo(i, 'D')) + 2.06 * 10 ** (- 7)) * Tavg ** 3);
Pc.l = (1 / (0.113 + 0.0032 * sum(i, n.l(i) * GD(i, 'a')) - sum(i, n.l(i) * GC(i, 'Pc'))) ** 2);
alpha.l = - 5.97214 - log(Pc.l / 1.013) + (6.09648 / Tbr.l) + 1.28862 * log(Tbr.l) - 0.169347 * Tbr.l ** 6;
beta.l = 15.2518 - (15.6875 / Tbr.l) - 13.4721 * log(Tbr.l) + 0.43577 * Tbr.l ** 6;
omega.l = alpha.l / beta.l;
Tavgr.l = Tavg / Tc.l;
Cpla.l = (1 / 4.1868) * (Cpoa.l + 8.314 * (1.45 + (0.45 / (1 - Tavgr.l)) + 0.25 * omega.l * (17.11 + 25.2 * ((1 - Tavgr.l) ** (1 / 3) / Tavgr.l) + 1.742 / (1 - Tavgr.l))));

Tcondr.l = Tcond / Tc.l;
h.l = (Tbr.l * log(Pc.l / 1.013)) / (1 - Tbr.l);
G.l = 0.4835 + 0.4605 * h.l;
k.l = ((h.l / G.l) - (1 + Tbr.l)) / ((3 + Tbr.l) * (1 - Tbr.l) ** 2);
Pvcr.l = EXP((- G.l / Tcondr.l) * (1 - Tcondr.l ** 2 + k.l * (3 + Tcondr.l) * (1 - Tcondr.l) ** 3));
Pver.l = EXP((- G.l / Tevapr.l) * (1 - Tevapr.l ** 2 + k.l * (3 + Tevapr.l) * (1 - Tevapr.l) ** 3));
Pvc.l = Pvcr.l * Pc.l;
Pve.l = Pver.l * Pc.l;

YA.l = 1;
YC.l = 0;
YM.l = 0;


***    Limits    ***
Hvb.lo = 0;
Hve.lo = HveR;
Tc.lo = 0.01;
Tb.lo = 0;
Tbr.lo = 0.01;
Tbr.up = 0.99;
Tevapr.lo = 0.01;
Tevapr.up = 0.99;

Cpoa.lo = 0;
Pc.lo = 0.1;
Tavgr.lo = 0.01;
Tavgr.up = 0.99;
Cpla.lo = 0;
Cpla.up = CplaR;

Tcondr.lo = 0.01;
Tcondr.up = 0.99;
h.lo = 0;
G.lo = 0;
Pvcr.lo = 0.000001;
Pvcr.up = 0.99;
Pver.lo = 0.000001;
Pver.up = 0.99;
Pvc.lo = 1.1;
Pvc.up = 14;
Pve.lo = 1.1;

n.lo(i) = nL(i);
n.up(i) = nU(i);

ZB.up = 4;
ZS.up = 15;
ZSR.up = 15;
ZD.up = 15;
ZDR.up = 15;
ZT.up = 15;


equations
obj

eqbinary

eqHvb, eqTb, eqTc, eqTbr, eqTevapr, eqHve

eqCpoa, eqPc, eqAlpha, eqBeta, eqOmega, eqTavgr, eqCpla

eqTcondr, eqH, eqG, eqK, eqPvcr, eqPver, eqPvc, eqPve

eqnmin, eqnmax

eqYA1, eqYA2, eqYC1, eqYC2, eqYM1, eqYM2, eqYAmin, eqYAmax, eqYCmin, eqYCmax, eqYMmin, eqYMmax, eqYMctrt1

eqYMctrt2

eqYR1, eqYR2, eqYRmin, eqYRmax

eqodd

eqbondmin

eqbondmax

eqYSDx1, eqYSDx2, eqYSDy1, eqYSDy2, eqYSDz1, eqYSDz2, eqYSDxmin, eqYSDxmax, eqYSDymin, eqYSDymax, eqYSDzmin, eqYSDzmax, eqYSDctrt
eqYSTx1, eqYSTx2, eqYSTy1, eqYSTy2, eqYSTz1, eqYSTz2, eqYSTxmin, eqYSTxmax, eqYSTymin, eqYSTymax, eqYSTzmin, eqYSTzmax, eqYSTctrt

eqmxdgroup

eql, equ, eqgroupmin, eqgroupmax

eqtypeS, eqtypeSR, eqtypeD, eqtypeDR, eqtypeT

eqm1, eqm2, eqoctet

eqIntcut
;

***    Objective function    ***
obj..            OF =E= Cpla / Hve;

***    Binary definition of n(i)    ***
eqbinary(i)..    n(i) =E= nL(i) + sum(bin $ (ord(bin) <= (Kmax + 1)), (2 ** (ord(bin) - 1)) * y(i, bin));

***    Thermodynamic constraints    ***
eqHvb..          Hvb =E= 15.3 + sum(i, n(i) * GC(i, 'Hvb'));
eqTb..           Tb =E= 198.2 + sum(i, n(i) * GC(i, 'Tb'));
eqTc..           Tc =E= Tb / (0.584 + 0.965 * sum(i, n(i) * GC(i, 'Tc')) - (sum(i, n(i) * GC(i, 'Tc'))) ** 2);
eqTbr..          Tbr =E= Tb / Tc;
eqTevapr..       Tevapr =E= Tevap / Tc;
eqHve..          Hve =E= Hvb * ((1 - Tevapr) / (1 - Tbr)) ** 0.38;

***    Heat capacity    ***
eqCpoa..         Cpoa =E= (sum(i, n(i) * Cpo(i, 'A')) - 37.93 + (sum(i, n(i) * Cpo(i, 'B')) + 0.21) * Tavg + (sum(i, n(i) * Cpo(i, 'C')) - 3.91 * 10 ** (- 4)) * (Tavg ** 2) + (sum(i, n(i) * Cpo(i, 'D')) + 2.06 * 10 ** (- 7)) * Tavg ** 3);
eqPc..           Pc =E= (1 / (0.113 + 0.0032 * sum(i, n(i) * GD(i, 'a')) - sum(i, n(i) * GC(i, 'Pc'))) ** 2);
eqAlpha..        alpha =E= - 5.97214 - log(Pc / 1.013) + (6.09648 / Tbr) + 1.28862 * log(Tbr) - 0.169347 * Tbr ** 6;
eqBeta..         beta =E= 15.2518 - (15.6875 / Tbr) - 13.4721 * log(Tbr) + 0.43577 * Tbr ** 6;
eqOmega..        omega =E= alpha / beta;
eqTavgr..        Tavgr =E= Tavg / Tc;
eqCpla..         Cpla =E= (1 / 4.1868) * (Cpoa + 8.314 * (1.45 + (0.45 / (1 - Tavgr)) + 0.25 * omega * (17.11 + 25.2 * ((1 - Tavgr) ** (1 / 3) / Tavgr) + 1.742 / (1 - Tavgr))));

***    Vapour pressure    ***
eqTcondr..       Tcondr =E= Tcond / Tc;
eqH..            h =E= (Tbr * log(Pc / 1.013)) / (1 - Tbr);
eqG..            G =E= 0.4835 + 0.4605 * h;
eqK..            k =E= ((h / G) - (1 + Tbr)) / ((3 + Tbr) * (1 - Tbr) ** 2);
eqPvcr..         log(Pvcr) =E= (- G / Tcondr) * (1 - Tcondr ** 2 + k * (3 + Tcondr) * (1 - Tcondr) ** 3);
eqPver..         log(Pver) =E= (- G / Tevapr) * (1 - Tevapr ** 2 + k * (3 + Tevapr) * (1 - Tevapr) ** 3);
eqPvc..          Pvc =E= Pvcr * Pc;
eqPve..          Pve =E= Pver * Pc;

***    Structural constraints 1    ***
eqnmin..         2 =L= sum(i, n(i));
eqnmax..               sum(i, n(i)) =L= 4;

***    Structural constraints 2    ***
eqYA1 $ (sum(i, (GD(i, 'Yas') + GD(i, 'Yad')) * n.l(i)) = 0)..   YA =E= 0;
eqYA2 $ (sum(i, (GD(i, 'Yas') + GD(i, 'Yad')) * n.l(i)) >= 1)..  YA =E= 1;
eqYC1 $ (sum(i, (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) = 0)..   YC =E= 0;
eqYC2 $ (sum(i, (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) >= 1)..  YC =E= 1;
eqYM1 $ (sum(i, (GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) = 0)..   YM =E= 0;
eqYM2 $ (sum(i, (GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) >= 1)..  YM =E= 1;
eqYAmin..        YA =L= sum(i $ (GD(i, 'Yas') + GD(i, 'Yad') > 0), n(i));
eqYAmax..               sum(i $ (GD(i, 'Yas') + GD(i, 'Yad') > 0), n(i)) =L= Nmax * YA * sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and n.l(i) >= 1), 1);
eqYCmin..        YC =L= sum(i $ (GD(i, 'Ycs') + GD(i, 'Ycd') > 0), n(i));
eqYCmax..               sum(i $ (GD(i, 'Ycs') + GD(i, 'Ycd') > 0), n(i)) =L= Nmax * YC * sum(i $ ((GD(i, 'Ycs') + GD(i, 'Ycd') > 0) and n.l(i) >= 1), 1);
eqYMmin..        YM =L= sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) > 0), n(i));
eqYMmax..               sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) > 0), n(i)) =L= Nmax * YM * sum(i $ (((GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) > 0) and n.l(i) >= 1), 1);
eqYMctrt1..      YM =G= YA + YC - 1;

***    Structural constraints 3    ***
eqYMctrt2..      YM =L= YA + YC;

***    Structural constraints 4    ***
eqYR1 $ ((sum(i, (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) = 0) and (sum(i, (GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) = 0))..        YR =E= 0;
eqYR2 $ ((sum(i, (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) >= 1) or (sum(i, (GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) * n.l(i)) >= 1))..       YR =E= 1;
eqYRmin..        3 * YR =L= sum(i $ (GD(i, 'Ycs') + GD(i, 'Ycd') > 0), n(i));
eqYRmax..                   sum(i $ (GD(i, 'Ycs') + GD(i, 'Ycd') > 0), n(i)) =L= Nmax * YR * sum(i $ ((GD(i, 'Ycs') + GD(i, 'Ycd') > 0) and n.l(i) >= 1), 1);

***    Structural constraints 5    ***
eqodd..          sum(i $ mod(GD(i, 'b'), 2), n(i)) =E= 2 * ZB;

***    Structural constraints 6    ***
eqbondmin..      sum(i, n(i) * GD(i, 'b')) =G= 2 * (sum(i, n(i)) - 1);

***    Structural constraints 7    ***
eqbondmax..      sum(i, n(i) * GD(i, 'b')) =L= sum(i, n(i)) * (sum(i, n(i)) - 1);

***    Structural constraints 8    ***
eqYSDx1 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yad') > 0), n.l(i)) = 0)..       YSDx =E= 0;
eqYSDx2 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yad') > 0), n.l(i)) >= 1)..      YSDx =E= 1;
eqYSDy1 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yad') = 0), n.l(i)) = 0)..       YSDy =E= 0;
eqYSDy2 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yad') = 0), n.l(i)) >= 1)..      YSDy =E= 1;
eqYSDz1 $ (sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yad') > 0), n.l(i)) = 0)..       YSDz =E= 0;
eqYSDz2 $ (sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yad') > 0), n.l(i)) >= 1)..      YSDz =E= 1;
eqYSDxmin..      YSDx =L= sum(i $ (GD(i, 'Yas') * GD(i, 'Yad') > 0), n(i));
eqYSDxmax..               sum(i $ (GD(i, 'Yas') * GD(i, 'Yad') > 0), n(i)) =L= Nmax * YSDx * sum(i $ ((GD(i, 'Yas') * GD(i, 'Yad') > 0) and n.l(i) >= 1), 1);
eqYSDymin..      YSDy =L= sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yad') = 0), n(i));
eqYSDymax..               sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yad') = 0), n(i)) =L= Nmax * YSDy * sum(i $ ((GD(i, 'Yas') > 0 and GD(i, 'Yad') = 0) and n.l(i) >= 1), 1);
eqYSDzmin..      YSDz =L= sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yad') > 0), n(i));
eqYSDzmax..               sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yad') > 0), n(i)) =L= Nmax * YSDz * sum(i $ ((GD(i, 'Yas') = 0 and GD(i, 'Yad') > 0) and n.l(i) >= 1), 1);
eqYSDctrt..      YSDy + YSDz - 1 =L= YSDx + YR;

eqYSTx1 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yt') > 0), n.l(i)) = 0)..        YSTx =E= 0;
eqYSTx2 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yt') > 0), n.l(i)) >= 1)..       YSTx =E= 1;
eqYSTy1 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yt') = 0), n.l(i)) = 0)..        YSTy =E= 0;
eqYSTy2 $ (sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yt') = 0), n.l(i)) >= 1)..       YSTy =E= 1;
eqYSTz1 $ (sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yt') > 0), n.l(i)) = 0)..        YSTz =E= 0;
eqYSTz2 $ (sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yt') > 0), n.l(i)) >= 1)..       YSTz =E= 1;
eqYSTxmin..      YSTx =L= sum(i $ (GD(i, 'Yas') * GD(i, 'Yt') > 0), n(i));
eqYSTxmax..               sum(i $ (GD(i, 'Yas') * GD(i, 'Yt') > 0), n(i)) =L= Nmax * YSTx * sum(i $ ((GD(i, 'Yas') * GD(i, 'Yt') > 0) and n.l(i) >= 1), 1);
eqYSTymin..      YSTy =L= sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yt') = 0), n(i));
eqYSTymax..               sum(i $ (GD(i, 'Yas') > 0 and GD(i, 'Yt') = 0), n(i)) =L= Nmax * YSTy * sum(i $ ((GD(i, 'Yas') > 0 and GD(i, 'Yt') = 0) and n.l(i) >= 1), 1);
eqYSTzmin..      YSTz =L= sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yt') > 0), n(i));
eqYSTzmax..               sum(i $ (GD(i, 'Yas') = 0 and GD(i, 'Yt') > 0), n(i)) =L= Nmax * YSTz * sum(i $ ((GD(i, 'Yas') = 0 and GD(i, 'Yt') > 0) and n.l(i) >= 1), 1);
eqYSTctrt..      YSTY + YSTz - 1 =L= YSTx;

***    Structural constraints 9    ***
eqmxdgroup..     sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 1), n(i)) =L= sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad')) * (GD(i, 'Ycs') + GD(i, 'Ycd')) > 0), (GD(i, 'b') - 2) * n(i)) + sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 1), (GD(i, 'b') - 2) * n(i)) + Nmax * (1 - YM) * sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 1 and n.l(i) >= 1), 1);

***    Structural constraints 10    ***
eql..            l =E= - Nmax * (sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 3 and n.l(i) >= 1), 1) + 2 * sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 4 and n.l(i) >= 1), 1));
equ..            u =E= Nmax * sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 1 and n.l(i) >= 1), 1);
eqgroupmin..     l * YR =L= sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 1), n(i)) - 2 - sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 3), n(i)) - 2 * sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 4), n(i));
eqgroupmax..     sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 1), n(i)) - 2 - sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 3), n(i)) - 2 * sum(i $ ((GD(i, 'Yas') + GD(i, 'Yad') > 0) and GD(i, 'b') = 4), n(i)) =L= u * YR;

***    Structural constraints 11    ***
eqtypeS..        sum(i, n(i) * GD(i, 'Yas')) =E= 2 * ZS;
eqtypeSR..       sum(i, n(i) * GD(i, 'Ycs')) =E= 2 * ZSR;
eqtypeD..        sum(i, n(i) * GD(i, 'Yad')) =E= 2 * ZD;
eqtypeDR..       sum(i, n(i) * GD(i, 'Ycd')) =E= 2 * ZDR;
eqtypeT..        sum(i, n(i) * GD(i, 'Yt')) =E= 2 * ZT;

***    Odele-Macchietto    ***
eqm1 $ (YM.l = 0 and YC.l = 0)..                                 m =E= 1;
eqm2 $ ((YC.l = 1 or YM.l = 1) and (sum(i, n.l(i)) <= 6))..      m =E= 0;
eqoctet..        sum(i, n(i) * (2 - GD(i, 'b'))) =E= 2 * m;


***    Integer Cut    ***
eqIntcut(c)$(dyn(c))..   sum((i, bin), yv(i, bin, c) * y(i, bin)) - sum((i, bin), (1 - yv(i, bin, c)) * y(i, bin)) =L= sum((i, bin), yv(i, bin, c)) - 1;



y.fx(i, bin) $ (ord(bin) > (Kmax + 1)) = 0;

***    Model options    ***
model    APOProject / all /;
option   MINLP = BARON;
option   optcr = 0.1;


dyn(c) = no;

yv(i, bin, c) = 0;

alias(c, cc);

loop(cc,
         solve APOProject minimising OF using MINLP;

         yv(i, bin, cc) = y.l(i, bin);
         OFv(cc) = OF.l;
         Cplav(cc) = Cpla.l;
         Hvev(cc) = Hve.l;
         nv(i, cc) = n.l(i);

         dyn(cc) = yes;
);

***    Display    ***
display  OFv, Cplav, Hvev, yv, nv;
