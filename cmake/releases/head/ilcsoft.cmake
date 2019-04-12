
# base packages: create links
ilcsoft_link_package( PACKAGE MySQL )
ilcsoft_link_package( PACKAGE Boost )
ilcsoft_link_package( PACKAGE Eigen )
ilcsoft_link_package( PACKAGE ILCUTIL )
ilcsoft_link_package( PACKAGE CondDBMySQL )
ilcsoft_link_package( PACKAGE CED )
ilcsoft_link_package( PACKAGE FastJet )
ilcsoft_link_package( PACKAGE FastJetcontrib )
ilcsoft_link_package( PACKAGE XercesC )
ilcsoft_link_package( PACKAGE QT )
ilcsoft_link_package( PACKAGE CLHEP )
ilcsoft_link_package( PACKAGE GSL )
ilcsoft_link_package( PACKAGE ROOT )
ilcsoft_link_package( PACKAGE Geant4 )

# ILCSoft packages
ilcsoft_install_package( PACKAGE PandoraPFANew )
ilcsoft_install_package( PACKAGE GEAR )
ilcsoft_install_package( PACKAGE LCIO )
ilcsoft_install_package( PACKAGE LCCD )
ilcsoft_install_package( PACKAGE RAIDA )
ilcsoft_install_package( PACKAGE Marlin )
ilcsoft_install_package( PACKAGE DD4hep )
ilcsoft_install_package( PACKAGE MarlinUtil )
ilcsoft_install_package( PACKAGE PandoraAnalysis )
ilcsoft_install_package( PACKAGE LCFIVertex )
ilcsoft_install_package( PACKAGE CEDViewer )
ilcsoft_install_package( PACKAGE GBL )
ilcsoft_install_package( PACKAGE aidaTT )
ilcsoft_install_package( PACKAGE KiTrack )
ilcsoft_install_package( PACKAGE KalTest )
ilcsoft_install_package( PACKAGE KalDet )
ilcsoft_install_package( PACKAGE DDKalTest )
ilcsoft_install_package( PACKAGE MarlinTrk )
ilcsoft_install_package( PACKAGE KiTrackMarlin )
ilcsoft_install_package( PACKAGE ILDConfig )
ilcsoft_install_package( PACKAGE BBQ )
ilcsoft_install_package( PACKAGE PathFinder )
ilcsoft_install_package( PACKAGE MarlinTPC )
ilcsoft_install_package( PACKAGE lcgeo )
# TODO Need to deal with this one ...
# ilcsoft_install_package( PACKAGE DD4hepExamples )

# Marlin packages
ilcsoft_install_marlinpkg( PACKAGE Overlay DEPENDS CLHEP MarlinUtil )
ilcsoft_install_marlinpkg( PACKAGE Garlic DEPENDS GEAR MarlinUtil ROOT )
ilcsoft_install_marlinpkg( PACKAGE MarlinDD4hep DEPENDS DD4hep ROOT DDKalTest )
ilcsoft_install_marlinpkg( PACKAGE DDMarlinPandora DEPENDS MarlinUtil DD4hep ROOT PandoraPFANew MarlinTrk )
ilcsoft_install_marlinpkg( PACKAGE MarlinFastJet DEPENDS FastJet )
ilcsoft_install_marlinpkg( PACKAGE LCTuple DEPENDS ROOT )
ilcsoft_install_marlinpkg( PACKAGE MarlinKinfit DEPENDS GEAR GSL )
ilcsoft_install_package( PACKAGE MarlinReco )
ilcsoft_install_marlinpkg( PACKAGE MarlinTrkProcessors DEPENDS ROOT GSL MarlinUtil KalTest KalDet MarlinTrk KiTrack KiTrackMarlin )
ilcsoft_install_marlinpkg( PACKAGE MarlinKinfitProcessors DEPENDS GEAR GSL )
ilcsoft_install_marlinpkg( PACKAGE ILDPerformance DEPENDS ROOT )
ilcsoft_install_marlinpkg( PACKAGE Clupatra DEPENDS ROOT RAIDA MarlinUtil KalTest MarlinTrk )
ilcsoft_install_marlinpkg( PACKAGE Physsim DEPENDS ROOT )
ilcsoft_install_marlinpkg( 
  PACKAGE FCalClusterer 
  DEPENDS DD4hep ROOT GSL 
  GIT_USER "FCALSW"
  GIT_REPO "FCalClusterer"
)
ilcsoft_install_marlinpkg( 
  PACKAGE LCFIPlus 
  DEPENDS GEAR ROOT MarlinUtil LCFIVertex 
  GIT_USER "lcfiplus"
  GIT_REPO "LCFIPlus"
)
ilcsoft_install_marlinpkg( PACKAGE ForwardTracking DEPENDS GEAR ROOT GSL MarlinUtil MarlinTrk )
ilcsoft_install_marlinpkg( PACKAGE ConformalTracking DEPENDS ROOT MarlinTrk )
ilcsoft_install_marlinpkg( 
  PACKAGE LICH 
  DEPENDS ROOT MarlinUtil 
  GIT_USER "danerdaner"
  GIT_REPO "LICH"
)

