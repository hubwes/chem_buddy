final List<String> cations = [
  'NH4+', 'Li+', 'Na+', 'K+', 'Rb+', 'Cs+', 'Fr+', 'Be2+', 'Mg2+', 'Ca2+',
  'Sr2+', 'Ba2+', 'Ra2+', 'Sc3+', 'Y3+', 'La3+', 'Ce3+', 'Pr3+', 'Nd3+',
  'Pm3+', 'Sm3+', 'Eu3+', 'Gd3+', 'Tb3+', 'Dy3+', 'Ho3+', 'Er3+', 'Tm3+',
  'Yb3+', 'Lu3+', 'Ti3+', 'Ti4+', 'Zr4+', 'Hf4+', 'V3+', 'V4+', 'V5+',
  'Nb5+', 'Ta5+', 'Cr2+', 'Cr3+', 'Cr6+', 'Mo6+', 'W6+', 'Mn2+', 'Mn3+',
  'Mn4+', 'Mn6+', 'Mn7+', 'Fe2+', 'Fe3+', 'Co2+', 'Co3+', 'Ni2+', 'Ni3+',
  'Cu1+', 'Cu2+', 'Zn2+', 'Ag1+', 'Cd2+', 'Hg2+', 'Hg1+', 'Al3+', 'Ga3+',
  'In3+', 'Tl1+', 'Tl3+', 'Pb2+', 'Pb4+', 'Sn2+', 'Sn4+', 'Bi3+', 'Bi5+',
  'Sb3+', 'Sb5+', 'Te4+', 'Te6+', 'Po4+', 'Po6+', 'As3+', 'As5+'
];

final List<String> anions = [
  'F-', 'Cl-', 'Br-', 'I-', 'O2-', 'S2-', 'Se2-', 'Te2-', 'Po2-', 'OH-',
  'CN-', 'OCN-', 'SCN-', 'NO2-', 'NO3-', 'HSO4-', 'SO4(2-)', 'SO3(2-)',
  'S2O3(2-)', 'S2O4(2-)', 'S2O5(2-)', 'S2O6(2-)', 'S2O7(2-)', 'S2O8(2-)',
  'CO3(2-)', 'HCO3-', 'SiO3(2-)', 'SiO4(4-)', 'PO4(3-)', 'HPO4(2-)',
  'H2PO4-', 'AsO4(3-)', 'AsO3(3-)', 'HAsO4(2-)', 'H2AsO4-', 'BO3(3-)',
  'HBO3(2-)', 'H2BO3-', 'C2O4(2-)', 'CrO4(2-)', 'Cr2O7(2-)', 'MnO4-',
  'MnO4(2-)', 'HPO3(2-)', 'H2PO3-', 'HAsO3(2-)', 'H2AsO3-', 'VO4(3-)',
  'VO3-', 'VO2+', 'VO4(2-)', 'VO3(2-)', 'MoO4(2-)', 'WO4(2-)', 'ClO-',
  'ClO2-', 'ClO3-', 'ClO4-', 'BrO-', 'BrO2-', 'BrO3-', 'BrO4-', 'IO-',
  'IO2-', 'IO3-', 'IO4-', 'IO6(5-)'
];

final Map<String, List<String>> cationReactions = {
  'NH4+': [
    'Reakcja z NaOH: NH4+ + OH- -> NH3 (g) + H2O',
    'Reakcja z Nessler\'s reagent: żółty osad'
  ],
  'Li+': [
    'Reakcja z Na2CO3: brak osadu',
    'Reakcja płomieniowa: czerwony płomień'
  ],
  'Na+': [
    'Reakcja z K2CO3: brak osadu',
    'Reakcja płomieniowa: żółty płomień'
  ],
  'K+': [
    'Reakcja z HCl: brak osadu',
    'Reakcja płomieniowa: fioletowy płomień'
  ],
  'Ca2+': [
    'Reakcja z Na2CO3: Ca2+ + CO32- -> CaCO3 (biały osad)',
    'Reakcja płomieniowa: ceglasty płomień'
  ],
  'Mg2+': [
    'Reakcja z NaOH: Mg2+ + 2OH- -> Mg(OH)2 (biały osad)',
    'Reakcja z NH4Cl: brak osadu'
  ]
};

final Map<String, List<String>> anionReactions = {
  'Cl-': [
    'Reakcja z AgNO3: Cl- + Ag+ -> AgCl (biały osad)',
    'Reakcja z H2SO4: wydzielanie HCl (g)'
  ],
  'SO4-': [
    'Reakcja z BaCl2: SO42- + Ba2+ -> BaSO4 (biały osad)',
    'Reakcja z Pb(NO3)2: SO42- + Pb2+ -> PbSO4 (biały osad)'
  ],
  'NO3-': [
    'Reakcja z FeSO4: brązowy pierścień',
    'Reakcja z Cu: niebieski roztwór'
  ],
  'CO3-': [
    'Reakcja z HCl: CO32- + 2H+ -> CO2 (g) + H2O',
    'Reakcja z Ca(OH)2: CO32- + Ca2+ -> CaCO3 (biały osad)'
  ]
};