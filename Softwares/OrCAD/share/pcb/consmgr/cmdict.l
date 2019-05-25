; $Header: cmdict.l,v 1.47 02/04/20 01:18:38 putnam $
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Cadence Design Systems 
;
; (C) COPYRIGHT, Cadence Design Systems, Inc. 1997-2007
; All Rights Reserved
; Licensed Materials - Property of Cadence Design Systems
;
; No part of this file may be reproduced, stored in a retrieval system,
; or transmitted in any form or by any means --- electronic, mechanical,
; photocopying, recording, or otherwise --- without prior written permission
; of Cadence Design Systems, Inc. 
;
; WARRANTY:
; Use all material in this file at your own risk.  Cadence Design Systems
; makes no claims about any material contained in this file.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; REDS Dictionary definitions
;
; Format:
;  ( Attribute|Bundle
;    ( Name <name> )
;    ( Description "<text>" )
;    ( Value (DataType <type>) (Units <unitType> <unit> <dimension> <number>) (Range (Min <minval>) (Max <maxval>)) (ValueType <type>) (Status <status>) (Format <fmt>))
;    ( Objects (ValidObjects <objectTypes>) (NoInherit (<objectType1> <objectType2>) )
;    ( Analysis (MeasureName <name>) (Status <status>) )
;    ( RelatedProperties <names> )
;    ( PropertyToRestrict <restriction> )
;    ( Aliases <names> )
;    ( Version <startver> )
;	 ( Tiering (Tier <tier>) (Options <options>) )
;  )
;
; where:
;    Name: Attribute or Bundle Name (<= 64 characters).
;
;    Description: Free form attribute description text (<= 255 characters). Used for simple help.
;
;    DisplayName: Default display name when presenting attribute to the user.
;
;    DataType: The data type for the attribute. Set to one of:
;               (dEnum <enum strings>), (dChar), (dShort), (dInteger), (dFloat), (dDouble), (dString),
;               (dListEnum <enum strings>), (dListChar), (dListShort), (dListLong), (dListInteger), (dListFloat),
;               (dListDouble), (dListString), (dMinDouble), (dMaxDouble), (dBoolean), (dListBoolean),
;               (dEnumOrString <enum strings>)
;
;    Units: The units of measurement for the attribute. Set to one of:
;             uTime, uResistance, uResistanceTolerance, uCapacitance, uVoltage, uFrequency, uPower, uCurrent,
;             uTemperature, uInductance, uElectricalConductivity, uThermalConductivity, uThermalResistance,
;             uVelocity, uDesign, uNoiseVoltage, uParasiticResistance, uParasiticCapacitance, uPhaseTol,
;             uPercentage, uJitterTime, uRelPropDelay, uRelSkew, uInteger, uDesignOrXWidth, uNone
;
;    Range: The minimum and/or maximum allowable values for the attribute, expressed in the
;           units of measurement.
;
;    ValueType: The type of values stored in the data.
;         vDefault - single value. Used in conjunction with the DataType.
;         vPercentage - single numerical input for specifying a percentage.
;         vThreshold - High and Low values.
;         vEdge - Rising and Falling values.
;         vRange - Minimum and Maximum values.
;         vLayer - Layer specific values.
;         vDiffPairLayer - Layer specific differential pair values.
;         vCT - Constraint Templates references.
;         vTT - Topology Templates references.
;         vLayerNames - Layer names.
;         vMatrix - Matrix of values. Currently only supports a 2x4 configuration.
;         vEnum - Enums.
;         vDeltaTol - Delta and Tolerance values.
;         vRelSkew - Rise, Fall (delta) and Tolerance values.
;         vDiffPair - Differential pair values, with access to the DiffPair calculator.
;         vEditOrPickFromList - Value may be entered or picked up from a list.
;         vLayerSets - Layer Sets need to be differentiated to use Allegro or own dlg.
;         vWebLink - Value is link to WEB - need to launch web explorer.
;         vBitPattern - Bit pattern (introduced for Custom Stimulus).
;         vViaList - Needs to present the via list editing dialog.
;         vEnumOrString - value may be represented as a enum (should be translated to some defualt value) 
;                          or as a single value. Use in conjunction with dEnumOrString 
;         vEnumOrInteger- value may be represented as a enum (should be translated to some defualt value) 
;                          or as a single integer value. Use in conjunction with dEnumOrString and uInteger
;         vNets - Value which is comprised of a list of Net names.
;         vIBDMapping - Value which created by mapping a design object to interface definition object.
;         vPercentOptional - Value with an optional percent.
;         vDelayWithUnits - Delat value with units (length, time, percent).
;
;    LegalExpression: Regular expression describing legal format for string-based attributes. e.g.
;
;    MaxLength: Maximum length for string-based attributes.
;
;    Status: The following additional attribute characteristics are allowed:
;              sProperty       - Attribute is a property.
;              sConstraint     - Attribute is a constraint.
;              sActual         - Attribute represents an actual value for a specific domain (e.g. actualStubLength).
;              sResult         - Attribute is a calculated result.
;              sVStatus        - Attribute represents the verification status of the constraint.
;              sHidden         - Attribute is for internal CM use only.
;              sObsolete       - Attribute has been obsoleted and no longer will be shown or written out.
;              sNoInherit      - Attribute is never inherited within the specified ValidObjects.
;              sReadOnly       - Attribute cannot be set through the UI.
;              sCanBeLocked    - Attribute can be locked.
;              sVMode          - Attribute is a verification mode.
;              sControl        - Attribute for controlling the behaviour of the CM.
;              sDrvrPin        - Attribute would be defined on Driver Pins.
;              sRcvrPin        - Attribute would be defined on Recevier Pins.
;              sNoUnitStr      - Attribute does not require unit string appended to
;                                its value when sync'd with host application.
;              sPackage        - Attribute is required for packaging.
;              sPrefix         - Attribute requires a prefix.
;              sSuffix         - Attribute requires a suffix.
;              sPreserveName   - Attribute's name is case sensitive.
;              sUpperCaseValue - Attribute's values should all be in uppercase.
;              sInstances      - Attribute uses instances to support multiple overrides.
;              sAskAppForData  - Attribute value may be requested from the app "on fly"
;              sAskAppForDataOnce  - Attribute value may be requested from the app "on fly",
;                                    but query the app ONLY ONE time.
;              sMayUseViaZ     - Attribute may use ViaZ info in the calculatons. Attribute added to meet requirements of the
;                               "Functional Specification for Constraint Manager Support for Via Delay". For the purpose of the
;                               Status Line update need to mark properties may use ViaZ
;              sDelayRelated    - Attribute may use PIN_DELAY info in the calculatons.
;              sProcessAllObjects - Attribute contains a reference to an object that has links to other objects (such as a DRC).
;                                   Whenever this attribute is processed for an object, all related objects must be processed.
;              sForceOverrideAudit- Force Audit.
;                                   For example: PIN_DELAY may be overwritten, but it can not be constraint. So, Audit Constraints
;                                   skips check / report, but user want to see it. Flag must solve mentioned problem
;              sDictDataDisabled   - Attribute is disabled
;              sDictDataExpertOnly - Attribute appears only in expert mode.
;              sDerivedData        - Attribute is not an attribute in the Allegro database: it is native data.
;              sNoFlow             - Property Flow: NO transfer to / from Physical
;              sPackageCreatePart  - Property Flow: Create a new physical part for each unique property value
;              sPackageSameValueOnly-Property Flow: Package instances with the same property value in one physical part
;              sPackageSameValue   - Property Flow: Package instances with the same property value in one physical part. If spare
;                                    sections exist package instances that do not have.
;              sNoEditor           - Attribute value should not be editable in any user interface
;              sCMEditOnly         - Attribute value can only be edited in Constraint Manager
;              sMultiGroupAltQuery - Attribute requires AlternateQuery MULTI_GROUP support.
;                                    It's internal CM stuff mainly required for display purposes and well covered in .mcf
;                                    file. Status needs to be in dictionary to cover Worksheet customization.
;                                    User may create user-defined column based on pre-defined attribute.
;                                    In this case need to setup AltQuery for column, and use this status flag for it.
;                                    In 15.5.1 it's equal sInstances
;              sNoMerge            - Attribute is not processed by Diff3.
;              sNoAliasMerge       - Attribute is not processed when alias is created/dissolved.
;              sWriteCMDBSaveOnly  - Attribute is only written to DCF file during CM DB Save.
;              sCMDefined          - Attribute is defined in CM for prototyping and will be automatically duplicated in Allegro.
;              sGroupEditOnly      - Attribute can only be edited on group objects.  Other objects can only inherit.
;              sOnlyREDSValidation - Attribute validation happens only on REDS level, skip UI validation
;                                    to protect attribute from re-formatting
;              sIgnoreConversion   - Preserve attribure from re-formatting on REDS level. So far works only for dString.
;              sUserDefined        - Attribute is intended to be user defined but the GUI is unable to generate the precise settings.
;                                    Attribute will be written to the DictionaryExtensions section of the customization files.
;                                    Allowed for prototyping Advanced Constraints measurements but should never be delivered to ClearCase.
;
;    Category:
;        cBubble          - Attribute will be bubbled to XNet, from a Net, if Retain ECns on Nets is not in CM Server.
;                           If Bundle is categorized, individual portions SHOULD NOT unless existing code is updated appropriately
;
;    Format: C-style format string using to format value when converted from double to string 
;
;    ValidObjects: The type of object the attribute can be defined for:
;		NOTE: order in which supported csets are listed is important!!!
;			  attribute will be looked for exactly in that order
;                   oAll              - all objects.
;                   oSystem           - a system.
;                   oDesign           - a design (PCB).
;                   oBlock            - a schematic block (TBD).
;                   oECSet            - a collection of electrical constraints.
;                   oRoom             - a floor planning area.
;                   oPartDefn         - a Part Definition (7400)
;                   oPart             - a Part instance (U1)
;                   oGate             - a Gate definition or Gate instance.
;                   oPin              - a Pin definition (7400.1) or Pin instance (U1.1).
;                   oECSetPin         - an Electrical CSet pin (OUT1.1).
;                   oXnet             - an extended net.
;                   oNet              - a signal as defined by the schematic's connectivity.
;                   oPinPair          - a pin pair, possibly driver/receiver, possibly not.
;                   oECSetPinPair     - a ECset pin pair, possibly driver/receiver, possibly not.
;                   oResult           - a result.
;                   oClineSeg         - a Cline segment.
;                   oRegion           - a technology specific region.
;                   oDiffPair         - a pair of Nets or XNets which represent a differential pair.
;                   oBus              - a collection of Nets or Xnets which represent a bus.
;                   oMatchGroup       - a collection of Xnet/Nets/PinPairs for matching.
;                   oECSetMatchGroup  - a collection of ECSet PinPairs for matching.
;                   oClass            - a collection of Nets or Xnets.
;                   oDRC              - a DRC object
;                   oIODriver         - a component instance with component class = DRIVER_CELL
;                   oIOTile           - a DB_TILE group, contents include drivers and die pins
;                   oIODie            - a component with matching DB_IC group
;                   oIOBus            - a grouping of drivers for signals on same bus
;                   oIODiffPair       - a pairing of drivers for a diff pair
;                   oElectricalDRCGroup - a group of electrical DRCs
;                   oSpacingDRCGroup  - a group of spacing DRCs
;                   oSameNetSpacingDRCGroup - a group of same-net spacing DRCs
;                   oPhysicalDRCGroup - a group of physical DRCs
;                   oDesignDRCGroup   - a group of design DRCs
;                   oExternalDRCGroup - a group of external DRCs
;                   oAssemblyDRCGroup - a group of assembly DRCs
;                   oRegion           - a P&S constraint region or region-class or
;                                       region-class-class
;                   oNetClassClass    - a spacing constraint class-to-class
;                   oNetClass         - a P&S constraint class
;                   oSCSet            - a spacing constraint set
;                   oSNSCSet          - a same-net spacing constraint set
;                   oPCSet            - a physical constraint set
;                   oLayer            - an etch layer
;                   oLayerSet         - a layer set
;                   oRatBundle        - a ratsnest bundle
;                   oFromTo           - a from-to pin pair (ratsnest pin pair)
;
;    Analysis: Analysis related information:
;          MeasureName:
;              Length             - Use the object's length (etch + Manhatten of Rats).
;              EtchLength         - Use the object's existing etch length.
;              ManhattanLength    - Use the object's Manhattan rat length.
;              PropDelay          - Use the object's Propagation Delay (including Manhatten of Rats).
;              EtchPropDelay      - Use the object's existing etch Propagation Delay.
;              ManhattanPropDelay - Use the object's Manhattan Propagation Delay.
;              PercentManhattan   - Use the object's routing as a % of the total manhattan.
;
;          Status:
;              sDRCVerify   - DRC type constraint/actual
;              sSimVerify   - Simulation type constraint/actual
;              sXtalkVerify - Xtalk type constraint/actual
;              sCustomMeasure - custom measurement actual
;              sDiffPairVerify - Diff Pair type constraint
;              sECSetMappingVerify - constraints used to indicate ecset mapping results
;
;              sVerifyOnChange     - Actuals must be redone on constraint change.
;              sCnsForAnalysis     - Actuals can not be computed unless constraint exists.
;              sFullyRouted        - Attribute can only be analyzed if fully routed.
;
;              sMinConstraint      - Use compare function which treats constraint as a minimum
;                                    requirement for the object, in design units.
;              sMaxConstraint      - Use compare function which treats constraint as a maximum
;                                    requirement for the object, in design units.
;              sTargetConstraint   - (also sTarget, sTargetOneTolerance) Use compare function that
;                                    treats constraint as a target value requirement for the object
;                                    within a related +/- tolerance.
;              sTargetTwoTolerance - Use compare function that treats constraint as a target value 
;                                    requirement for the object within related positive and negative
;                                    tolerances.
;              sTolConstraint      - Use compare function that treats constraint as a tolerance value
;                                    applied to a group of objects.  The actual values for each of the
;                                    members of the group must be within the tolerance of each other.
;              sPassFailConstraint - Constraint is used to turn the check on or off.  The actual values
;                                    indicate pass or fail.  No comparison is needed.
;              sCMAnalysisMode     - Attribute is a Custom Measurement Analysis Mode.
;
;          Pass|Fail:
;              "<reason>" - Actual's pass or fail reason. If checker doesn't return an actual,
;                           the <reason> is used to populate _VSTATUS and the status is set to
;                           pass (green) or fail (red).
;
;    NoInherit: Allows one to turn-off attribute inheritance between specific "associations" of the
;               ValidObjects. If the 'sNoInherit' status is not set, an attribute is valid for
;               the entire hierarchy of objects (oXnet->oNet->oPinPair). The NoInherit term allows
;               one to specifically turn-off a specific inheritance (eg oNet oPinPair).
;
;    RelatedProperties: properties related to the attribute. Typically only specified if the attribute
;                       is a constraint.
;
;    RelatedAnalysis: constraints which share the same analysis results. i.e validating one constraint
;                     calculates the results for the other(s).
;
;    PropertyToRestrict: restrictions relative to other properties.
;
;    Aliases: Allows one to define aliases for the attribute name.
;
;    Version: software version in which the attribute first appeared.
;
;	 Tiers: Licensing requirements, that need to be met in order for the attribute NOT to be disabled. If both tier and option are specified, at least one needs to be in use (e.g. (Tier tBase) (Option tMiniaturization) will be DISabled ONLY if we use L (< perf L) and NO Miniaturization option)
;			Tier: Minimum licence required for the attribute to be ENabled
;					tL
;					tBase
;					tXL
;					tTooHigh - matches Allegro's ATTR_VISIBLE_NEVER - when the property should be hidden by all tiers; works only with when CM_VERIFY_TIERING_CONSISTENCY env variable is set
;			Options: Option keys, valid are:
;					tGRE
;					tRatbundle
;					tMiniaturization
;					tHighSpeed
;					  pseudo-options (not in official tiering)
;					  tTotalEtch			- total etch length for OrCad Pro (TISimpleElecOk)
;

(AttributeDictionary

;
; SIMULATION DISCIPLINE
; ===========================

; Electrical Properties Tab
; -------------------------
( Attribute
  (Name PULSE_PARAM_FREQ)
  (Description "Nets switch frequency")
  (Value (DataType (dDouble)) (Units uFrequency MHz) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
;*******************
;Period should never be updated. Period is used to display the time
;domain value for PULSE_PARAM_FREQ which stores the actual value.
;*******************
( Attribute
  (Name PULSE_PARAM_PERIOD)
  (Description "Clock period" )
  (Value (DataType (dDouble)) (Units uTime ns) (Range (Min 0.0)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name PULSE_PARAM_DUTY_CYCLE)
  (Description "Clock duty cycle expressed as a percentage for the time High")
  (Value (DataType (dLong)) (Units uPercentage %) (ValueType vPercentage) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name PULSE_PARAM_JITTER)
  (Description "Amount of clock jitter expressed as an absolute value")
  (Value (DataType (dDouble)) (Units uJitterTime ps) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name PULSE_PARAM_MEASURE_CYCLE)
  (Description "Clock cycle for measuring during simulation")
  (Value (DataType (dLong)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name PULSE_PARAM_COFF)
  (Description "Amount of clock jitter expressed as an absolute value")
  (Value (DataType (dDouble)) (Units uTime ns) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name PULSE_PARAM_AOFF)
  (Description "Amount of clock jitter expressed as an absolute value")
  (Value (DataType (dDouble)) (Units uTime ns) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name PULSE_PARAM_BPAT)
  (Description "Bit Pattern")
  (Value (DataType (dString)) (ValueType vBitPattern) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oBus oDiffPair oNetGroup oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Bundle
  (Name PULSE_PARAM)
  (Value (ValueType vPulseParam) (Category cBubble))
  (RelatedProperties PULSE_PARAM_FREQ PULSE_PARAM_DUTY_CYCLE PULSE_PARAM_JITTER PULSE_PARAM_MEASURE_CYCLE PULSE_PARAM_BPAT PULSE_PARAM_COFF PULSE_PARAM_AOFF)
)

; Switch/Settle Tab
; -----------------
( Attribute
  (Name MIN_FIRST_SWITCH)
  (Description "Minimum allowable first switch delay for a Path")
  (Value (DataType (dListDouble)) (Units uTime ns) (ValueType vEdge) (Status sMinConstraint sCMEditOnly))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oECSetPinPair oResult))
  (Analysis (Status sSimVerify sSSDelayVerify))
  (RelatedProperties MIN_FIRST_SWITCH_ACTUAL MIN_FIRST_SWITCH_MARGIN MIN_FIRST_SWITCH_VSTATUS)
  (RelatedAnalysis MAX_FINAL_SETTLE MAX_OVERSHOOT MIN_NOISE_MARGIN EDGE_SENS FIRST_INCIDENT)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Bundle
  (Name MIN_FIRST_SWITCH)
  (Value (ValueType vSSDelay) (Category cBubble))
  (RelatedProperties MIN_FIRST_SWITCH)
)
( Attribute
  (Name MIN_FIRST_SWITCH_ACTUAL)
  (Description "Actual first switch delay for the path")
  (Value (DataType (dListDouble)) (Units uTime ns) (Status sActual sNoInherit sSimVerify sSSDelayVerify sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MIN_FIRST_SWITCH_MARGIN)
  (Description "Actual switch delay minus Minimum switch delay")
  (Value (DataType (dDouble)) (Units uTime ns) (Status sResult sNoInherit sSimVerify sSSDelayVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MIN_FIRST_SWITCH_VSTATUS)
  (Description "Min First Switch verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sSimVerify sSSDelayVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MIN_FIRST_SWITCH_NODE)
  (Description "Min First Switch measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSSDelayVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MIN_FIRST_SWITCH_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair oResult))
)
( Attribute
  (Name MIN_FIRST_SWITCH_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair oResult))
)
( Attribute
  (Name MAX_FINAL_SETTLE)
  (Description "Maximum allowable final settle delay for a Path")
  (Value (DataType (dListDouble)) (Units uTime ns) (ValueType vEdge) (Status sMaxConstraint sCMEditOnly))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oECSetPinPair oResult))
  (Analysis (Status sSimVerify sSSDelayVerify))
  (RelatedProperties MAX_FINAL_SETTLE_ACTUAL MAX_FINAL_SETTLE_MARGIN MAX_FINAL_SETTLE_VSTATUS)
  (RelatedAnalysis MIN_FIRST_SWITCH MAX_OVERSHOOT MIN_NOISE_MARGIN EDGE_SENS FIRST_INCIDENT)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Bundle
  (Name MAX_FINAL_SETTLE)
  (Value (ValueType vSSDelay) (Category cBubble))
  (RelatedProperties MAX_FINAL_SETTLE)
)
( Attribute
  (Name MAX_FINAL_SETTLE_ACTUAL)
  (Description "Actual final settle delay for the path")
  (Value (DataType (dListDouble)) (Units uTime ns) (Status sActual sNoInherit sSimVerify sSSDelayVerify sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MAX_FINAL_SETTLE_MARGIN)
  (Description "Maximum settle constraint minus actual settle delay")
  (Value (DataType (dDouble)) (Units uTime ns) (Status sResult sNoInherit sSimVerify sSSDelayVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MAX_FINAL_SETTLE_VSTATUS)
  (Description "Max Final Settle verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sSimVerify sSSDelayVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MAX_FINAL_SETTLE_NODE)
  (Description "Max Final Settle measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSSDelayVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name MAX_FINAL_SETTLE_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair oResult))
)
( Attribute
  (Name MAX_FINAL_SETTLE_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair oResult))
)

; Reflection Tab
; --------------
( Attribute
  (Name MAX_OVERSHOOT)
  (Description "Absolute overshoot voltage allowed")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (ValueType vThreshold) (Status sMaxConstraint sCMEditOnly sSimVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (RelatedProperties MAX_OVERSHOOT_ACTUAL MAX_OVERSHOOT_MARGIN MAX_OVERSHOOT_VSTATUS)
  (RelatedAnalysis MIN_FIRST_SWITCH MAX_FINAL_SETTLE MIN_NOISE_MARGIN EDGE_SENS FIRST_INCIDENT)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_OVERSHOOT_ACTUAL)
  (Description "Actual overshoot voltage")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (Status sActual sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_OVERSHOOT_MARGIN)
  (Description "Maximum overshoot minus actual overshoot")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sResult sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_OVERSHOOT_VSTATUS)
  (Description "Maximum overshoot verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_OVERSHOOT_NODE)
  (Description "Maximum Overshoot measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_OVERSHOOT_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name MAX_OVERSHOOT_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name MIN_NOISE_MARGIN)
  (Description "Minimum delta from the threshold after the net switches")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (ValueType vEdge) (Range (Min 0.0)) (Status sMinConstraint sCMEditOnly sSimVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (RelatedProperties MIN_NOISE_MARGIN_ACTUAL MIN_NOISE_MARGIN_MARGIN MIN_NOISE_MARGIN_VSTATUS)
  (RelatedAnalysis MIN_FIRST_SWITCH MAX_FINAL_SETTLE MAX_OVERSHOOT EDGE_SENS FIRST_INCIDENT)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MIN_NOISE_MARGIN_ACTUAL)
  (Description "Actual delta from threshold after the net switches")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (Status sActual sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MIN_NOISE_MARGIN_MARGIN)
  (Description "Actual delta from threshold after the net switches")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sResult sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MIN_NOISE_MARGIN_VSTATUS)
  (Description "Minimum noise margin verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MIN_NOISE_MARGIN_NODE)
  (Description "Minimum Noise margin measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MIN_NOISE_MARGIN_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name MIN_NOISE_MARGIN_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)

; SSN Tab
; -------
( Attribute
  (Name MAX_SSN)
  (Description "Maximum simultaneous switching noise allowed")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (ValueType vEdge) (Range (Min 0.0)) (Status sConstraint sCMEditOnly sSimVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (RelatedProperties MAX_SSN_ACTUAL MAX_SSN_MARGIN MAX_SSN_VSTATUS)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_SSN_POWER_BUS)
  (Description "Power bus associated with driver pin")
  (Value (DataType (dString)) (Status sProperty sReadOnly sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Domains dElectrical)  
)
( Attribute
  (Name MAX_SSN_GROUND_BUS)
  (Description "Ground bus associated with driver pin")
  (Value (DataType (dString)) (Status sProperty sReadOnly sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Domains dElectrical)  
)
( Attribute
  (Name MAX_SSN_ACTUAL)
  (Description "Actual simultaneous switching noise at steady state high:low")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (Status sActual sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_SSN_MARGIN)
  (Description "Worst case maximum minus actual simultaneous switching noise")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sResult sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_SSN_VSTATUS)
  (Description "Maximum Simultaneous switching noise verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_SSN_NODE)
  (Description "Maximum Simultaneous switching noise measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_SSN_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name MAX_SSN_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)

; Edge Distortions Tab
; --------------------
( Attribute
  (Name EDGE_SENS)
  (Description "Nets sensitivity to non-monotonicity")
  (Value (DataType (dEnum RISING FALLING BOTH NEITHER)) (ValueType vEnum) (Status sConstraint sCMEditOnly sSimVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (RelatedProperties EDGE_SENS_ACTUAL EDGE_SENS_MARGIN EDGE_SENS_VSTATUS)
  (RelatedAnalysis MIN_FIRST_SWITCH MAX_FINAL_SETTLE MAX_OVERSHOOT MIN_NOISE_MARGIN FIRST_INCIDENT)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name EDGE_SENS_ACTUAL)
  (Description "Is edge non-monotonic?")
  (Value (DataType (dListEnum PASS FAIL)) (Status sActual sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name EDGE_SENS_MARGIN)
  (Description "Is edge non-monotonic?")
  (Value (DataType (dDouble)) (Status sResult sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name EDGE_SENS_VSTATUS)
  (Description "Edge sensitivity verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name EDGE_SENS_NODE)
  (Description "Edge sensitivity measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name EDGE_SENS_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name EDGE_SENS_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name FIRST_INCIDENT)
  (Description "Flags whether a receiver is required to switch on the first incident wave")
  (Value (DataType (dEnum RISING FALLING BOTH NEITHER)) (ValueType vEnum) (Status sConstraint sCMEditOnly sSimVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (RelatedProperties FIRST_INCIDENT_ACTUAL FIRST_INCIDENT_MARGIN FIRST_INCIDENT_VSTATUS)
  (RelatedAnalysis MIN_FIRST_SWITCH MAX_FINAL_SETTLE MAX_OVERSHOOT MIN_NOISE_MARGIN EDGE_SENS)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name FIRST_INCIDENT_ACTUAL)
  (Description "Did receiver switch on first incident wave?")
  (Value (DataType (dListEnum PASS FAIL)) (Status sActual sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name FIRST_INCIDENT_MARGIN)
  (Description "Did receiver switch on first incident wave?")
  (Value (DataType (dDouble)) (Status sResult sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name FIRST_INCIDENT_VSTATUS)
  (Description "First incident switch verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name FIRST_INCIDENT_NODE)
  (Description "First Incident measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet  oResult))
)
( Attribute
  (Name FIRST_INCIDENT_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name FIRST_INCIDENT_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)

; Estimated Xtalk Tab
; -------------------
( Attribute
  (Name XTALK_ACTIVE_TIME)
  (Description "Clock cycle(s) when net is actively switching and creating noise")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name XTALK_SENSITIVE_TIME)
  (Description "Clock cycle(s) when net is sensitive to noise")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name XTALK_IGNORE_NETS)
  (Description "List of nets to ignore when calculating crosstalk")
  (Value (DataType (dString)) (Delimiter ",") (ValueType vNets) (Status sProperty sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Domains dElectrical)  
  (Tiering (Tier tXL) (Options tHighSpeed))
)

( Attribute
  (Name MAX_XTALK)
  (Description "Maximum allowable crosstalk from all aggressors")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (ValueType vThreshold) (Status sMaxConstraint sCMEditOnly sXtalkVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (RelatedProperties MAX_XTALK_ACTUAL MAX_XTALK_MARGIN MAX_XTALK_VSTATUS MAX_XTALK_EST_ACTUAL MAX_XTALK_EST_MARGIN MAX_XTALK_EST_VSTATUS)
  (Aliases MAX_XTALK_EST)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_XTALK_EST_ACTUAL)
  (Description "Actual crosstalk from all aggressors")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_XTALK_EST_MARGIN)
  (Description "Maximum crosstalk minus actual crosstalk")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sResult sNoInherit sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_XTALK_EST_VSTATUS)
  (Description "Maximum Xtalk verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_XTALK_EST_DRC)
  (Description "Estimated Crosstalk DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)

( Attribute
  (Name MAX_PEAK_XTALK)
  (Description "Maximum allowable crosstalk from a single aggressor")
  (Value (DataType (dListDouble)) (Units uNoiseVoltage mV) (ValueType vThreshold) (Status sMaxConstraint sCMEditOnly sXtalkVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (RelatedProperties MAX_PEAK_XTALK_ACTUAL MAX_PEAK_XTALK_MARGIN MAX_PEAK_XTALK_VSTATUS MAX_PEAK_XTALK_EST_ACTUAL MAX_PEAK_XTALK_EST_MARGIN MAX_PEAK_XTALK_EST_VSTATUS)
  (Aliases MAX_PEAK_XTALK_EST)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_PEAK_XTALK_EST_ACTUAL)
  (Description "Actual peak crosstalk from the single aggressors")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_PEAK_XTALK_EST_MARGIN)
  (Description "Maximum peak crosstalk minus actual peak crosstalk")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sResult sNoInherit sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_PEAK_XTALK_EST_VSTATUS)
  (Description "Maximum Peak Xtalk verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_PEAK_XTALK_EST_DRC)
  (Description "Estimated Peak Crosstalk DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oResult))
  (Tiering (Tier tXL) (Options tHighSpeed))
)

( Attribute
  (Name MAX_XTALK_VMODE)
  (Description "Maximum Xtalk verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAX_PEAK_XTALK_VMODE)
  (Description "Maximum Peak Xtalk verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)

; Simulated Xtalk Tab
; -------------------
; XTALK_ACTIVE_TIME defined above.
; XTALK_SENSITIVE_TIME defined above.
; XTALK_IGNORE_NETS defined above.
; MAX_XTALK defined above.
( Attribute
  (Name MAX_XTALK_ACTUAL)
  (Description "Actual crosstalk from all aggressors")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sActual sNoInherit sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_XTALK_MARGIN)
  (Description "Maximum crosstalk minus actual crosstalk")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sResult sNoInherit sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_XTALK_VSTATUS)
  (Description "Maximum Xtalk verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_XTALK_NODE)
  (Description "Xtalk measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_XTALK_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name MAX_XTALK_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
; MAX_PEAK_XTALK defined above.
( Attribute
  (Name MAX_PEAK_XTALK_ACTUAL)
  (Description "Actual peak crosstalk from the single aggressors")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sActual sNoInherit sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_PEAK_XTALK_MARGIN)
  (Description "Maximum peak crosstalk minus actual peak crosstalk")
  (Value (DataType (dDouble)) (Units uNoiseVoltage mV) (Status sResult sNoInherit sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_PEAK_XTALK_VSTATUS)
  (Description "Maximum Peak Xtalk verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_PEAK_XTALK_NODE)
  (Description "Peak Xtalk measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sXtalkVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oResult))
)
( Attribute
  (Name MAX_PEAK_XTALK_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)
( Attribute
  (Name MAX_PEAK_XTALK_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oResult))
)

; TIMING DISCIPLINE
; =================

; Setup/Hold tab
; --------------
( Attribute
  (Name CLOCK_NET)
  (Description "Clock net name")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
; PULSE_PARAM_PERIOD defined above
; PULSE_PARAM_JITTER defined above
( Attribute
  (Name CLK_2OUT_MIN)
  (Description "Internal minimum delay when a component is triggered by a clock pulse" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sProperty sDrvrPin sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair oPin))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name CLK_2OUT_MAX)
  (Description "Internal maximum delay when a component is triggered by a clock pulse" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sProperty sDrvrPin sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair oPin))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
; MIN_FIRST_SWITCH_ACTUAL defined above
; MAX_FINAL_SETTLE_ACTUAL defined above
( Attribute
  (Name TIMING_DELAY_OVERRIDE)
  (Description "Interconnect delay override used in setup/hold calculations" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sProperty sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name CLK_SKEW_MIN)
  (Description "Minimum skew between the clock arriving at the driver and receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sProperty sRcvrPin sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair oPin))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name CLK_SKEW_MAX)
  (Description "Maximum skew between the clock arriving at the driver and receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sProperty sRcvrPin sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair oPin))
  (Domains dElectrical)
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name TESTER_GUARDBAND)
  (Description "Tester guard band")
  (Value (DataType (dDouble)) (Units uTime ns) (Status sProperty sRcvrPin sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair oPin))
  (Domains dElectrical)
  (Tiering (Tier tBase))
)
( Attribute
  (Name MIN_SETUP)
  (Description "SETUP requirements for a Receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Range (Min 0.0)) (Status sMinConstraint sCMEditOnly sSimVerify sRcvrPin) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair oPin))
  (RelatedProperties CLOCK_NET PULSE_PARAM_FREQ PULSE_PARAM_JITTER CLK_2OUT_MIN CLK_2OUT_MAX CLK_SKEW_MIN CLK_SKEW_MAX MIN_FIRST_SWITCH_ACTUAL MAX_FINAL_SETTLE_ACTUAL TIMING_DELAY_OVERRIDE TESTER_GUARDBAND MIN_SETUP_ACTUAL MIN_SETUP_MARGIN MIN_SETUP_VSTATUS)
  (RelatedAnalysis MIN_FIRST_SWITCH MAX_FINAL_SETTLE MIN_HOLD)
  (Domains dElectrical)
  (Tiering (Tier tBase))
)
( Attribute
  (Name MIN_SETUP_ACTUAL)
  (Description "Actual SETUP for the Receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sActual sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_SETUP_MARGIN)
  (Description "SETUP margin for the Receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sResult sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_SETUP_VSTATUS)
  (Description "Minimum setup verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_SETUP_NODE)
  (Description "Minimum Setup measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_SETUP_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MIN_SETUP_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MIN_HOLD)
  (Description "HOLD requirements for a Receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sMinConstraint sCMEditOnly sSimVerify sRcvrPin) (Category cBubble))
  (Objects (ValidObjects oNetClass oBus oDiffPair oXnet oNet oPinPair oPin))
  (RelatedProperties CLOCK_NET PULSE_PARAM_FREQ PULSE_PARAM_JITTER CLK_2OUT_MIN CLK_2OUT_MAX CLK_SKEW_MIN CLK_SKEW_MAX MIN_FIRST_SWITCH_ACTUAL MAX_FINAL_SETTLE_ACTUAL TIMING_DELAY_OVERRIDE TESTER_GUARDBAND MIN_HOLD_ACTUAL MIN_HOLD_MARGIN MIN_HOLD_VSTATUS)
  (RelatedAnalysis MIN_FIRST_SWITCH MAX_FINAL_SETTLE MIN_SETUP)
  (Domains dElectrical)
  (Tiering (Tier tBase))
)
( Attribute
  (Name MIN_HOLD_ACTUAL)
  (Description "Actual HOLD for the Receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sActual sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_HOLD_MARGIN)
  (Description "HOLD margin for the Receiver" )
  (Value (DataType (dDouble)) (Units uTime ns) (Status sResult sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_HOLD_VSTATUS)
  (Description "Minimum hold verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_HOLD_NODE)
  (Description "Minimum hold measurement node location")
  (Value (DataType (dInteger)) (Status sActual sNoInherit sHidden sCMEditOnly sSimVerify))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
)
( Attribute
  (Name MIN_HOLD_WAVEID)
  (Description "Waveform Id for SigWave")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MIN_HOLD_WAVEFORMS)
  (Description "Waveform Matrix for SigWave")
  (Value (DataType (dListString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oPinPair))
  (Tiering (Tier tXL) (Options tHighSpeed))
)

; ROUTING DISCIPLINE
; ==================

; Routing Tab
; -----------

; sNoInherit for TOPOLOGY_TEMPLATE_MAPPING_MODE block to put info into Constraint Audit as overrides.
( Attribute
  (Name TOPOLOGY_TEMPLATE_MAPPING_MODE)
  (Description "Mapping mode when applying a template-defined schedule")
  (Value (DataType (dEnum PINUSE REFDES PINUSE_REFDES)) (ValueType vEnum) (Status sProperty sCMEditOnly sNoInherit))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name NET_SCHEDULE)
  (Description "Should the routing be verified against the schedule?")
  (Value (DataType (dEnum VERIFY DO_NOT_VERIFY)) (ValueType vEnum) (Status sProperty sCMEditOnly sVerifyOnChange) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Tiering (Tier tBase))
)
( Attribute
  (Name RATSNEST_SCHEDULE)
  (Description "Net schedule control")
  (Value (DataType (dEnum MIN_TREE MIN_DAISY_CHAIN SOURCE_LOAD_DAISY_CHAIN STAR FAR_END_CLUSTER)) (ValueType vEnum) 
         (Status sConstraint sCMEditOnly sDRCVerify sCanBeLocked sVerifyOnChange sCnsForAnalysis) (Category cBubble))
  (RelatedProperties NET_SCHEDULE RATSNEST_SCHEDULE_ACTUAL RATSNEST_SCHEDULE_MARGIN RATSNEST_SCHEDULE_VSTATUS)
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Tiering (Tier tBase))
)
( Attribute
  (Name RATSNEST_SCHEDULE_ACTUAL)
  (Description "Is the Net routed according to the schedule?")
  (Value (DataType (dEnum PASS FAIL)) (ValueType vEnum) (Status sActual sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name RATSNEST_SCHEDULE_MARGIN)
  (Description "Is the Net routed according to the schedule?")
  (Value (DataType (dDouble)) (Status sResult sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name RATSNEST_SCHEDULE_VSTATUS)
  (Description "Scheduling verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name RATSNEST_SCHEDULE_LSTATUS)
  (Description "Scheduling lock reason")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)
( Attribute
  (Name RATSNEST_SCHEDULE_DRC)
  (Description "Schedule DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)
( Attribute
  (Name IMPEDANCE_RULE)
  (Description "Defines the impedance requirements of a net")
  (Value (DataType (dDouble)) (Units uResistance Ohm) (Range (Min 0.0)) (Status sTargetConstraint sCMEditOnly sCnsForAnalysis))
  (Objects (ValidObjects oECSet oNetGroup oNetClass oBus oDiffPair oXnet oNet oPinPair oECSetPinPair oClineSeg oResult))
  (Analysis (Status sDRCVerify sImpedanceVerify sVerifyOnChange))
  (RelatedProperties IMPEDANCE_RULE_TOL IMPEDANCE_RULE_ACTUAL IMPEDANCE_RULE_MARGIN IMPEDANCE_RULE_VSTATUS)
  (Aliases IMPEDANCE_RULE_VAL)
  (Tiering (Tier tBase))
)
( Attribute
  (Name IMPEDANCE_RULE_TOL)
  (Description "Defines the impedance tolerance (absolute or percentage) of a net")
  (Value (DataType (dString)) (Units uResistanceTolerance Ohm) (Range (Min 0.0)) (Status sProperty sTolerance sCMEditOnly))
  (Objects (ValidObjects oECSet oNetGroup oNetClass oBus oDiffPair oXnet oNet oPinPair oECSetPinPair oClineSeg oResult))
  (Analysis (Status sVerifyOnChange sDRCVerify)) 
)
( Bundle
  (Name IMPEDANCE_RULE)
  (Value (ValueType vImpedance) (Category cBubble))
  (RelatedProperties IMPEDANCE_RULE IMPEDANCE_RULE_TOL)
)
( Attribute
  (Name IMPEDANCE_RULE_ACTUAL)
  (Description "Actual impedance of a net")
  (Value (DataType (dRangeDouble)) (Units uResistance Ohm) (Status sActual sDRCVerify sCnsForAnalysis sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetGroup oNetClass oBus oDiffPair oXnet oNet oPinPair oClineSeg oResult))
  (Analysis (Status sDRCVerify sImpedanceVerify))
)
( Attribute
  (Name IMPEDANCE_RULE_MARGIN)
  (Description "Actual impedance minus the target impedance +/- the tolerance")
  (Value (DataType (dDouble)) (Units uResistance Ohm) (Status sResult sNoInherit sDRCVerify sImpedanceVerify sCMEditOnly))
  (Objects (ValidObjects oNetGroup oDesign oNetClass oBus oDiffPair oXnet oNet oPinPair oClineSeg oResult))
)
( Attribute
  (Name IMPEDANCE_RULE_VSTATUS)
  (Description "Impedance verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sImpedanceVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetGroup oNetClass oBus oDiffPair oXnet oNet oPinPair oClineSeg oResult))
)
( Attribute
  (Name IMPEDANCE_RULE_DRC)
  (Description "Impedance DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sImpedanceVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oClineSeg oResult))
)
( Attribute
  (Name IMPEDANCE_RULE_VMODE)
  (Description "Impedance verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
)
( Attribute
  (Name STUB_LENGTH)
  (Description "Maximum stub length for daisy-chain type routing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sMaxConstraint sCMEditOnly sDRCVerify sNoUnitStr sCnsForAnalysis) (Category cBubble))
  (Objects (ValidObjects oECSet oNetGroup oNetClass oBus oDiffPair oXnet oNet))
  (RelatedProperties STUB_LENGTH_ACTUAL STUB_LENGTH_MARGIN STUB_LENGTH_VSTATUS)
  (Tiering (Tier tBase))
)
( Attribute
  (Name STUB_LENGTH_ACTUAL)
  (Description "Actual stub length for daisy-chain type routing")
  (Value (DataType (dMaxDouble)) (Units uDesign mil) (Status sActual sNoInherit sNoUnitStr sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oNetGroup oNetClass oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name STUB_LENGTH_MARGIN)
  (Description "Maximum stub length minus the actual stub length")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sResult sNoInherit sNoUnitStr sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name STUB_LENGTH_VSTATUS)
  (Description "Maximum stub-length verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name STUB_LENGTH_DRC)
  (Description "Stub-length DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)
( Attribute
  (Name STUB_LENGTH_VMODE)
  (Description "Maximum stub length verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases RATSNEST_SCHEDULE_VMODE)
)
( Attribute
  (Name MAX_VIA_COUNT)
  (Description "Maximum number of vias in a Net")
  (Value (DataType (dLong)) (Range (Min 0)) (Status sMaxConstraint sCMEditOnly sDRCVerify sCnsForAnalysis))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet) (NoInherit (oXnet oNet)))
  (RelatedProperties MAX_VIA_COUNT_ACTUAL MAX_VIA_COUNT_MARGIN MAX_VIA_COUNT_VSTATUS)
  (Tiering (Tier tBase))
)
( Attribute
  (Name MAX_VIA_COUNT_ACTUAL)
  (Description "Number of vias in a Net")
  (Value (DataType (dLong)) (Status sActual sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet) (NoInherit (oXnet oNet)))
)
( Attribute
  (Name MAX_VIA_COUNT_MARGIN)
  (Description "Maximum total vias minus the actual number of vias")
  (Value (DataType (dLong)) (Status sResult sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet) (NoInherit (oXnet oNet)))
)
( Attribute
  (Name MAX_VIA_COUNT_VSTATUS)
  (Description "Maximum via count verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet) (NoInherit (oXnet oNet)))
)
( Attribute
  (Name MAX_VIA_COUNT_DRC)
  (Description "Max via count DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet) (NoInherit (oXnet oNet)))
)
( Attribute
  (Name MAX_VIA_COUNT_VMODE)
  (Description "Maximum total vias verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign) (NoInherit (oXnet oNet)))
)
( Attribute
  (Name MATCH_VIA_COUNT)
  (Description "Match vias in a group of Nets")
  (Value (DataType (dEnum ON OFF)) (Range (Min 0)) (Status sPassFailConstraint sCMEditOnly sCnsForAnalysis sGroupEditOnly))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oMatchGroup oXnet oNet oPinPair))
  (Analysis (Status sPassFailConstraint sDRCVerify sFullyRouted))
  (RelatedProperties MATCH_VIA_COUNT_ACTUAL MATCH_VIA_COUNT_MARGIN MATCH_VIA_COUNT_VSTATUS MATCH_VIA_OBJECT_COUNT)
  (Version "16.3")
  (Tiering (Tier tL))
)
( Attribute
  (Name MATCH_VIA_COUNT_ACTUAL)
  (Description "Vias in a group of Nets are matched")
  (Value (DataType (dEnum PASS FAIL)) (Status sActual sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oMatchGroup oXnet oNet oPinPair))
  (Analysis (Status sFullyRouted))
  (Version "16.3")
)
( Attribute
  (Name MATCH_VIA_COUNT_MARGIN)
  (Description "Difference in actual matched vias among a group of Nets")
  (Value (DataType (dLong)) (Status sResult sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oMatchGroup oXnet oNet oPinPair))
  (Version "16.3")
)
( Attribute
  (Name MATCH_VIA_COUNT_VSTATUS)
  (Description "Match vias verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oMatchGroup oXnet oNet oPinPair))
  (Version "16.3")
)
( Attribute
  (Name MATCH_VIA_COUNT_DRC)
  (Description "Match vias DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oMatchGroup oXnet oNet oPinPair))
  (Version "16.3")
)
( Attribute
  (Name MATCH_VIA_COUNT_VMODE)
  (Description "Match vias verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oXnet oNet))
  (Version "16.3")
)
( Attribute
  (Name MATCH_VIA_OBJECT_COUNT)
  (Description "Number of vias on an object")
  (Value (DataType (dLong)) (Range (Min 0)) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair) (NoInherit (oXnet oPinPair) (oNet oPinPair)))
  (Analysis (MeasureName ViaCount))
  (Version "16.3")
)
( Attribute
  (Name MAX_EXPOSED_LENGTH)
  (Description "Maximum length of copper on the outside of the board")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sMaxConstraint sCMEditOnly sDRCVerify sNoUnitStr sCnsForAnalysis) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (RelatedProperties MAX_EXPOSED_LENGTH_ACTUAL MAX_EXPOSED_LENGTH_MARGIN MAX_EXPOSED_LENGTH_VSTATUS)
  (Tiering (Tier tBase))
)
( Attribute
  (Name MAX_EXPOSED_LENGTH_ACTUAL)
  (Description "Actual length of copper on the outside of the board")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sNoUnitStr sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name MAX_EXPOSED_LENGTH_MARGIN)
  (Description "Maximum exposed length minus the actual exposed length of copper")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sResult sNoInherit sNoUnitStr sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name MAX_EXPOSED_LENGTH_VSTATUS)
  (Description "Maximum exposed copper verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name MAX_EXPOSED_LENGTH_DRC)
  (Description "Max exposed length DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)
( Attribute
  (Name MAX_EXPOSED_LENGTH_VMODE)
  (Description "Maximum exposed length verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
)
( Attribute
  (Name MAX_PARALLEL)
  (Description "Maximum parallelism for wires")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vMatrix) (Status sConstraint sCMEditOnly sDRCVerify sVerifyOnChange sNoUnitStr sCnsForAnalysis))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (RelatedProperties MAX_PARALLEL_ACTUAL MAX_PARALLEL_MARGIN MAX_PARALLEL_VSTATUS)
  (Tiering (Tier tBase))
)
( Bundle
  (Name MAX_PARALLEL)
  (Value (ValueType vMatrix) (Category cBubble))
  (RelatedProperties MAX_PARALLEL)
)
( Attribute
  (Name MAX_PARALLEL_ACTUAL)
  (Description "Actual same-layer parallelism results for the routing")
  (Value (DataType (dEnum PASS FAIL)) (Status sActual sNoInherit sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name MAX_PARALLEL_MARGIN)
  (Description "Maximum parallelism minus the actual parallelism")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sResult sNoInherit sNoUnitStr sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name MAX_PARALLEL_VSTATUS)
  (Description "Maximum parrallism verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name MAX_PARALLEL_DRC)
  (Description "Max parallel DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)
( Attribute
  (Name MAX_PARALLEL_VMODE)
  (Description "Maximum parallelism verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
)

;
; PS (6/15/2004) Layer Sets
;
( Attribute
  (Name LAYERSET_GROUP)
  (Description "Routing layer sets")
  (Value (DataType (dString)) (ValueType vLayerSets) (Status sConstraint sCMEditOnly sDRCVerify sVerifyOnChange sNoUnitStr sCnsForAnalysis) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (RelatedProperties LAYERSET_GROUP_ACTUAL LAYERSET_GROUP_MARGIN LAYERSET_IGNORED_LENGTH LAYERSET_GROUP_VMODE)
  (Version "15.5")
  (Tiering (Tier tBase))
)
( Attribute
  (Name LAYERSET_GROUP_ACTUAL)
  (Description "Actual routing layers")
  (Value (DataType (dEnum PASS FAIL)) (Status sActual sNoInherit sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Version "15.5")
)
( Attribute
  (Name LAYERSET_GROUP_MARGIN)
  (Description "")
  (Value (DataType (dString)) (Status sResult sNoInherit sNoUnitStr sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Version "15.5")
)
( Attribute
  (Name LAYERSET_GROUP_VSTATUS)
  (Description "Layer Sets verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Version "15.5")
)
( Attribute
  (Name LAYERSET_GROUP_DRC)
  (Description "Layer Sets DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
  (Version "15.5")
)
( Attribute
  (Name LAYERSET_GROUP_VMODE)
  (Description "Layer Sets verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sProcessAllObjects sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "15.5")
)
( Attribute
  (Name LAYERSET_IGNORED_LENGTH)
  (Description "Ignored length for an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Version "15.5")
)

; Propagation Tab
; ---------------
( Attribute
  (Name PROPAGATION_DELAY_PATH_TYPE)
  (Description "Apply delay/length constraints to various Path types")
  (Value (DataType (dEnum L:S D:R AD:AR)) (ValueType vEnum) (Status sProperty sCMEditOnly))
  (Analysis (Status sVerifyOnChange sDRCVerify sScheduleVerify))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (RelatedProperties PROPAGATION_DELAY_MIN_ACTUAL PROPAGATION_DELAY_MIN_MARGIN PROPAGATION_DELAY_MIN_VSTATUS PROPAGATION_DELAY_MAX_ACTUAL PROPAGATION_DELAY_MAX_MARGIN PROPAGATION_DELAY_MAX_VSTATUS)
)
( Attribute
  (Name PROPAGATION_DELAY_MIN)
  (Description "Minimum allowable propagation delay/length for an object")
  (Value (DataType (dString)) (Units uMaxMinProp ns) (ValueType vDelayWithUnits) (Range (Min 0.0)) (Status sMinConstraint sCMEditOnly))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oECSetPinPair))
  (Analysis (Status sDRCVerify sScheduleVerify sCnsForAnalysis sFullyRouted))
  (RelatedProperties PROPAGATION_DELAY_PATH_TYPE PROPAGATION_DELAY_MIN_ACTUAL PROPAGATION_DELAY_MIN_MARGIN PROPAGATION_DELAY_MIN_VSTATUS)
  (PropertyToRestrict (fMaxConstraint PROPAGATION_DELAY_MAX))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MIN_ACTUAL)
  (Description "Actual propagation delay/length for an object")
  (Value (DataType (dString)) (Units uMaxMinProp ns) (Status sActual sNoInherit sDRCVerify sScheduleVerify sMayUseViaZ sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Analysis (Status sFullyRouted))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MIN_MARGIN)
  (Description "Actual propagation delay/length minus minimum propagation delay/length")
  (Value (DataType (dString)) (Units uMaxMinProp ns) (Status sResult sNoInherit sDRCVerify sScheduleVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MIN_VSTATUS)
  (Description "Minimum propagation delay verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sScheduleVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MIN_DRC)
  (Description "Min prop delay DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sScheduleVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MIN_VMODE)
  (Description "Minimum propagation delay/length verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases PROPAGATION_DELAY_MAX_VMODE PROPAGATION_DELAY_VMODE)
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MAX)
  (Description "Maximum allowable propagation delay/length for an object")
  (Value (DataType (dString)) (Units uMaxMinProp ns) (ValueType vDelayWithUnits) (Range (Min 0.0)) (Status sMaxConstraint sCMEditOnly))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oECSetPinPair))
  (Analysis (Status sDRCVerify sScheduleVerify sCnsForAnalysis))
  (RelatedProperties PROPAGATION_DELAY_PATH_TYPE PROPAGATION_DELAY_MAX_ACTUAL PROPAGATION_DELAY_MAX_MARGIN PROPAGATION_DELAY_MAX_VSTATUS)
  (PropertyToRestrict (fMinConstraint PROPAGATION_DELAY_MIN))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MAX_ACTUAL)
  (Description "Actual propagation delay/length for an object")
  (Value (DataType (dString)) (Units uMaxMinProp ns) (Status sActual sNoInherit sDRCVerify sScheduleVerify sMayUseViaZ sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MAX_MARGIN)
  (Description "Maximum propagation delay/length minus actual propagation delay/length")
  (Value (DataType (dString)) (Units uMaxMinProp ns) (Status sResult sNoInherit sDRCVerify sScheduleVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MAX_VSTATUS)
  (Description "Maximum propagation delay verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sScheduleVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Tiering (Tier tBase))
)
( Attribute
  (Name PROPAGATION_DELAY_MAX_DRC)
  (Description "Max prop delay DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sScheduleVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair))
  (Tiering (Tier tBase))
)
( Bundle
  (Name PROPAGATION_DELAY)
  (Value (ValueType vPropDelay) (Category cBubble))
  (RelatedProperties PROPAGATION_DELAY_PATH_TYPE PROPAGATION_DELAY_MIN PROPAGATION_DELAY_MAX)
  (Aliases DELAY_RULE)
)

; Total Etch Length Tab
; ---------------------
( Attribute
  (Name TOTAL_ETCH_LENGTH_MIN)
  (Description "Minimum allowable total etch length for an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sMinConstraint sCMEditOnly))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Analysis (Status sMinConstraint sDRCVerify sFullyRouted))
  (RelatedProperties TOTAL_ETCH_LENGTH_MIN_ACTUAL TOTAL_ETCH_LENGTH_MIN_MARGIN TOTAL_ETCH_LENGTH_MIN_VSTATUS)
  (PropertyToRestrict (fMaxConstraint TOTAL_ETCH_LENGTH_MAX))
  (Tiering (Tier tBase) (Options tTotalEtch))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MIN_ACTUAL)
  (Description "Actual total etch for an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
  (Analysis (MeasureName EtchLength) (Status sDRCVerify sFullyRouted))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MIN_MARGIN)
  (Description "Actual total etch length minus minimum total etch length")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sResult sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MIN_VSTATUS)
  (Description "Minimum total etch length verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MIN_DRC)
  (Description "Min total etch DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MIN_VMODE)
  (Description "Minimum total etch length verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases TOTAL_ETCH_LENGTH_MAX_VMODE TOTAL_ETCH_LENGTH_VMODE)
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MAX)
  (Description "Maximum total etch length for an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sMaxConstraint sCMEditOnly))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Analysis (Status sMaxConstraint sDRCVerify))
  (RelatedProperties TOTAL_ETCH_LENGTH_MAX_ACTUAL TOTAL_ETCH_LENGTH_MAX_MARGIN TOTAL_ETCH_LENGTH_MAX_VSTATUS)
  (PropertyToRestrict (fMinConstraint TOTAL_ETCH_LENGTH_MIN))
  (Tiering (Tier tBase) (Options tTotalEtch))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MAX_ACTUAL)
  (Description "Actual total etch length for an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
  (Analysis (MeasureName EtchLength) (Status sDRCVerify))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MAX_MARGIN)
  (Description "Maximum total etch length minus actual total etch length")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sResult sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MAX_VSTATUS)
  (Description "Maximum total etch length verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name TOTAL_ETCH_LENGTH_MAX_DRC)
  (Description "Max total etch DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)
( Bundle
  (Name TOTAL_ETCH_LENGTH)
  (Value (ValueType vMinMaxLen) (Category cBubble))
  (RelatedProperties TOTAL_ETCH_LENGTH_MIN TOTAL_ETCH_LENGTH_MAX)
)

( Attribute
  (Name UNROUTED_LENGTH_ACTUAL)
  (Description "Estimated Length of an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
  (Analysis (MeasureName ManhattanLength))
)
( Attribute
  (Name UNROUTED_LENGTH_ACTUAL_VSTATUS)
  (Description "Estimated Length verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)
( Attribute
  (Name PERCENT_MANHATTAN_ACTUAL)
  (Description "Actual percent manhattan for an object")
  (Value (DataType (dLong)) (Units uPercentage %) (ValueType vPercentage) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
  (Analysis (MeasureName PercentManhattan) (Status sFullyRouted))
)
( Attribute
  (Name PERCENT_MANHATTAN_ACTUAL_VSTATUS)
  (Description "Percent manhattan verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
)

; Differential Impedance
; ----------------------
( Attribute
  (Name DIFF_IMPEDANCE_RULE)
  (Description "Defines the differentil impedance requirements of an object")
  (Value (DataType (dDouble)) (Units uResistance Ohm) (Range (Min 0.0)) (Status sTargetConstraint sCMEditOnly sCMDefined sCnsForAnalysis))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (RelatedProperties DIFF_IMPEDANCE_RULE_TOL DIFF_IMPEDANCE_RULE_ACTUAL DIFF_IMPEDANCE_RULE_MARGIN DIFF_IMPEDANCE_RULE_VSTATUS)
)
( Attribute
  (Name DIFF_IMPEDANCE_RULE_TOL)
  (Description "Defines the differential impedance tolerance (absolute or percentage) of an object")
  (Value (DataType (dString)) (Units uResistanceTolerance Ohm) (ValueType vPercentOptional) (Range (Min 0.0)) (Status sProperty sTolerance sCMEditOnly sCMDefined))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name DIFF_IMPEDANCE_RULE_ACTUAL)
  (Description "Actual differential impedance of an object")
  (Value (DataType (dRangeDouble)) (Units uResistance Ohm) (Status sActual sCnsForAnalysis sNoInherit sCMDefined sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Analysis (MeasureName DifferentialImpedance))
)
( Attribute
  (Name DIFF_IMPEDANCE_RULE_MARGIN)
  (Description "Actual differential impedance minus the target impedance +/- the tolerance")
  (Value (DataType (dDouble)) (Units uResistance Ohm) (Status sResult sNoInherit sCMDefined sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name DIFF_IMPEDANCE_RULE_VSTATUS)
  (Description "Differential impedance verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMDefined sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name DIFF_IMPEDANCE_RULE_DRC)
  (Description "Differential impedance DRC object")
  (Value (DataType (dString)) (Status sActual sNoInherit sHidden sCMDefined sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
)

( Attribute
  (Name MAX_BRANCHES)
  (Description "Defines the maximum number of branches allowed in a Net")
  (Value (DataType (dLong)) (Range (Min 0)) (Status sMaxConstraint sCMEditOnly sCMDefined sCnsForAnalysis))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (RelatedProperties MAX_BRANCHES_ACTUAL MAX_BRANCHES_MARGIN MAX_BRANCHES_VSTATUS)
)
( Attribute
  (Name MAX_BRANCHES_ACTUAL)
  (Description "Number of branches in a Net")
  (Value (DataType (dLong)) (Status sActual sNoInherit sCMDefined sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Analysis (MeasureName BranchCount))
)
( Attribute
  (Name MAX_BRANCHES_MARGIN)
  (Description "Maximum number of branches minus the actual number of branches")
  (Value (DataType (dLong)) (Status sResult sNoInherit sCMDefined sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name MAX_BRANCHES_VSTATUS)
  (Description "Maximum branches verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sCMDefined sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)

; Relative Propagation Tab
; ------------------------
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_TARGET)
  (Description "Target Pin Pair when defining relative constraint requirements")
  (Value (DataType (dString)) (Status sProperty sVMode sCMEditOnly))
  (Objects (ValidObjects oMatchGroup oECSetMatchGroup) (NoInherit (oXnet oPinPair) (oNet oPinPair)))
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_PATH_TYPE)
  (Description "Auto-generate Pin Pairs for the Xnet/Nets in the Group")
  (Value (DataType (dEnum L:S D:R AD:AR)) (ValueType vEnum) (Status sProperty sInstances sCMEditOnly sMultiGroupAltQuery))
  (Objects (ValidObjects oMatchGroup oECSetMatchGroup oXnet oNet) (NoInherit (oXnet oPinPair) (oNet oPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
  (Analysis (Status sVerifyOnChange sDRCVerify sRelPropDelayVerify sCMEditOnly))
  (RelatedProperties RELATIVE_PROPAGATION_DELAY_ACTUAL RELATIVE_PROPAGATION_DELAY_MARGIN RELATIVE_PROPAGATION_DELAY_PLUS_MINUS RELATIVE_PROPAGATION_DELAY_VSTATUS)
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_SCOPE)
  (Description "Scope when applying an Electrical CSet Relative/Match Group")
  (Value (DataType (dEnum L G B C N)) (ValueType vEnumSpecial)
         (Status sProperty sVerifyOnChange sDRCVerify sRelPropDelayVerify sInstances sCMEditOnly sMultiGroupAltQuery))
  (Objects (ValidObjects oMatchGroup oECSetMatchGroup oXnet oNet oPinPair oECSetPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair) (oECSetMatchGroup oECSetPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
  (Analysis (Status sDRCVerify sRelPropDelayVerify))
  (RelatedProperties RELATIVE_PROPAGATION_DELAY_ACTUAL RELATIVE_PROPAGATION_DELAY_MARGIN RELATIVE_PROPAGATION_DELAY_PLUS_MINUS RELATIVE_PROPAGATION_DELAY_VSTATUS)
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY)
  (Description "Propagation delay/length skew constraint for a group of objects")
  (Value (DataType (dListString)) (ValueType vDeltaTol) (Units uMatchProp ns)
         (Status sTargetConstraint sCMEditOnly sInstances sMultiGroupAltQuery))
  (Objects (ValidObjects oMatchGroup oECSetMatchGroup oXnet oNet oPinPair oECSetPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair) (oECSetMatchGroup oECSetPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
  (Analysis (Status sDRCVerify sRelPropDelayVerify sCnsForAnalysis sVerifyOnChange))
  (RelatedProperties RELATIVE_PROPAGATION_DELAY_PATH_TYPE RELATIVE_PROPAGATION_DELAY_SCOPE RELATIVE_PROPAGATION_DELAY_ACTUAL RELATIVE_PROPAGATION_DELAY_MARGIN RELATIVE_PROPAGATION_DELAY_PLUS_MINUS RELATIVE_PROPAGATION_DELAY_VSTATUS)
  (Tiering (Tier tBase))
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_ACTUAL)
  (Description "Actual propagation delay/length skew for a group of objects")
  (Value (DataType (dString)) (Units uMatchProp ns) (Status sActual sNoInherit sInstances sMayUseViaZ sCMEditOnly sDelayRelated sMultiGroupAltQuery))
  (Objects (ValidObjects oMatchGroup oXnet oNet oPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
  (Analysis (Status sDRCVerify sRelPropDelayVerify))
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_MARGIN)
  (Description "Maximum minus actual propagation delay/length skew")
  (Value (DataType (dString)) (Units uMatchProp ns) (Status sResult sNoInherit sInstances sCMEditOnly sDelayRelated sMultiGroupAltQuery))
  (Objects (ValidObjects oDesign oMatchGroup oXnet oNet oPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
  (Analysis (Status sDRCVerify sRelPropDelayVerify))
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_PLUS_MINUS)
  (Description "Object is longer (+) or shorter (-) than target plus delta. Not populated when tolerance-only constraint is set")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sRelPropDelayVerify sDelayRelated sInstances sCMEditOnly sMultiGroupAltQuery))
  (Objects (ValidObjects oPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
)
( Attribute
  (Name RELATIVE_PROPAGATION_OBJECT_LENGTH)
  (Description "Length of an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sRelPropDelayVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair)))
  (Analysis (MeasureName EtchLength) )
)
( Attribute
  (Name RELATIVE_PROPAGATION_OBJECT_DELAY)
  (Description "Delay of an object")
  (Value (DataType (dDouble)) (Units uTime ns) (Status sActual sNoInherit sRelPropDelayVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair)))
  (Analysis (MeasureName PropDelay) )
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_VSTATUS)
  (Description "Propagation delay/length skew verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sRelPropDelayVerify sDelayRelated sInstances sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_DRC)
  (Description "Relative prop delay DRC object")
  (Value (DataType (dString)) (Status sActual sHidden sDRCVerify sRelPropDelayVerify sDelayRelated sInstances sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oResult) (NoInherit (oXnet oPinPair) (oNet oPinPair)) (ParentObjects oMatchGroup oECSetMatchGroup))
)
( Attribute
  (Name RELATIVE_PROPAGATION_DELAY_VMODE)
  (Description "Propagation delay/length skew verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign) (NoInherit (oXnet oPinPair) (oNet oPinPair)))
)
( Attribute
  (Name BUS_SCOPE_BUS_NAME)
  (Description "Store the Bus name used for creating Bus scope group")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oMatchGroup))
)
( Attribute
  (Name BUS_SCOPE_ECSET_GROUP_NAME)
  (Description "Store the ECSet Group name used for creating Bus scope group")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oMatchGroup))
)
( Attribute
  (Name CLASS_SCOPE_CLASS_NAME)
  (Description "Store the Class name used for creating Class scope group")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oMatchGroup))
)

( Bundle
  (Name RELATIVE_PROPAGATION_DELAY)
  (Value (ValueType vRelPropDelay) (Category cBubble))
  (RelatedProperties RELATIVE_PROPAGATION_DELAY_SCOPE RELATIVE_PROPAGATION_DELAY_PATH_TYPE RELATIVE_PROPAGATION_DELAY)
  (Aliases MATCHED_DELAY)
)

; Differential Pair Tab
; ---------------------
; Allegro DB needs to update its boolean to an enum/string.
( Attribute
  (Name DIFFP_GATHER_CONTROL)
  (Description "Ignore length between Pins and gather point when calculating uncoupled length")
  (Value (DataType (dEnum Ignore Include)) (ValueType vEnum) (Status sProperty sCMEditOnly) (Category cBubble))
  (Analysis (Status sVerifyOnChange sDiffPairVerify))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oDiffPair oXnet oNet oPinPair oResult))
  (RelatedProperties DIFFP_UNCOUPLED_LENGTH_ACTUAL DIFFP_UNCOUPLED_LENGTH_MARGIN GATHER_LENGTH_IGNORED DIFFP_UNCOUPLED_LENGTH_VSTATUS )
  (Version "15.0")
  (Tiering (Tier tL) (Options tTotalEtch))
)
( Attribute
  (Name GATHER_LENGTH_IGNORED)
  (Description "Ignored length for an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oPinPair oResult))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_UNCOUPLED_LENGTH)
  (Description "Maximum uncoupled length")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sMaxConstraint sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oDiffPair oXnet oNet oPinPair oResult))
  (Analysis (Status sMaxConstraint sDRCVerify sCnsForAnalysis sFullyRouted sDiffPairVerify))
  (RelatedProperties DIFFP_GATHER_CONTROL DIFFP_PRIMARY_GAP DIFFP_COUPLED_PLUS DIFFP_COUPLED_MINUS DIFFP_UNCOUPLED_LENGTH_ACTUAL DIFFP_UNCOUPLED_LENGTH_MARGIN GATHER_LENGTH_IGNORED DIFFP_UNCOUPLED_LENGTH_VSTATUS )
  (Version "15.0")
  (Tiering (Tier tL) (Options tTotalEtch))
)
( Attribute
  (Name DIFFP_UNCOUPLED_LENGTH_ACTUAL)
  (Description "DiffPair maximum uncoupled length")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sDRCVerify sDiffPairVerify sMayUseViaZ sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oResult))
  (Analysis (Status sFullyRouted))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_UNCOUPLED_LENGTH_MARGIN)
  (Description "DiffPair maximum uncoupled length margin")
  (Value (DataType (dDouble)) (Status sResult sNoInherit sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oDiffPair oBus oXnet oNet oPinPair oResult))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_UNCOUPLED_LENGTH_VSTATUS)
  (Description "DiffPair maximum uncoupled length verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_UNCOUPLED_LENGTH_DRC)
  (Description "DiffPair maximum uncoupled length DRC object")
  (Value (DataType (dString)) (Status sActual sHidden sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oResult))
  (Version "15.0")
)
; Phase control is now obsolete. Seperate constraints for static and dynamic checks.
( Attribute
  (Name DIFFP_PHASE_CONTROL)
  (Description "Used to control the type of phase tolerance check")
  (Value (DataType (dEnum Static Dynamic)) (ValueType vEnum) (Status sProperty sCMEditOnly sObsolete) (Category cBubble))
  (Analysis (Status sVerifyOnChange sDiffPairVerify))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
  (RelatedProperties DIFFP_PHASE_TOL_ACTUAL DIFFP_PHASE_TOL_MARGIN DIFFP_PHASE_TOL_VSTATUS )
  (Version "16.3")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
; Static Phase Tolerance
( Attribute
  (Name DIFFP_PHASE_TOL)
  (Description "Maximum static time/distance for DiffPair to be out-of-phase")
  (Value (DataType (dString)) (Units uPhaseTol ns) (Range (Min 0.0)) (Status sMaxConstraint sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oDiffPair oXnet oNet oPinPair oResult))
  (Analysis (Status sMaxConstraint sDRCVerify sCnsForAnalysis sFullyRouted sDiffPairVerify sDelayRelated))
  (RelatedProperties DIFFP_PHASE_TOL_ACTUAL DIFFP_PHASE_TOL_MARGIN DIFFP_PHASE_TOL_VSTATUS )
  (Version "15.0")
  (Tiering (Tier tBase))
)
( Attribute
  (Name DIFFP_PHASE_TOL_ACTUAL)
  (Description "DiffPair static length/time tolerance")
  (Value (DataType (dMaxDouble)) (Units uPhaseTol ns) (Status sActual sNoInherit sDRCVerify sDiffPairVerify sMayUseViaZ sDelayRelated sCMEditOnly))
  (Objects (ValidObjects  oXnet oNet oPinPair oResult))
  (Analysis (Status sFullyRouted))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_PHASE_TOL_MARGIN)
  (Description "DiffPair static length/time tolerance margin")
  (Value (DataType (dDouble)) (Units uPhaseTol ns) (Status sResult sNoInherit sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oDiffPair oBus oXnet oNet oPinPair oResult))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_PHASE_TOL_VSTATUS)
  (Description "DiffPair static length/time tolerance verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_PHASE_TOL_DRC)
  (Description "DiffPair static length/time tolerance DRC object")
  (Value (DataType (dString)) (Status sActual sHidden sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oResult))
  (Version "15.0")
)
; Dynamic Phase Tolerance
( Attribute
  (Name DIFFP_PHASE_MAX_LENGTH)
  (Description "The maximum distance allowed once a Differential Pair exceeds the phase tolerance constraint.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sNoUnitStr sDiffPairVerify) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oDiffPair oXnet oNet oPinPair oResult))
  (Version "16.3")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name DIFFP_PHASE_TOL_DYNAMIC)
  (Description "Maximum dynamic time/distance for DiffPair to be out-of-phase")
  (Value (DataType (dString)) (Units uPhaseTol mil) (Range (Min 0.0)) (Status sMaxConstraint sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oECSet oNetClass oNetGroup oDiffPair oXnet oNet oPinPair oResult))
  (Analysis (Status sMaxConstraint sDRCVerify sCnsForAnalysis sFullyRouted sDiffPairVerify sDelayRelated))
  (RelatedProperties DIFFP_PHASE_TOL_DYNAMIC_ACTUAL DIFFP_PHASE_TOL_DYNAMIC_MARGIN DIFFP_PHASE_TOL_DYNAMIC_VSTATUS )
  (Version "16.3")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name DIFFP_PHASE_TOL_DYNAMIC_ACTUAL)
  (Description "DiffPair length tolerance")
  (Value (DataType (dMaxDouble)) (Units uPhaseTol mil) (Status sActual sNoInherit sDRCVerify sDiffPairVerify sMayUseViaZ sDelayRelated sCMEditOnly))
  (Objects (ValidObjects  oXnet oNet oPinPair oResult))
  (Analysis (Status sFullyRouted))
  (Version "16.3")
)
( Attribute
  (Name DIFFP_PHASE_TOL_DYNAMIC_MARGIN)
  (Description "DiffPair length tolerance margin")
  (Value (DataType (dDouble)) (Units uPhaseTol mil) (Status sResult sNoInherit sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oDiffPair oBus oXnet oNet oPinPair oResult))
  (Version "16.3")
)
( Attribute
  (Name DIFFP_PHASE_TOL_DYNAMIC_VSTATUS)
  (Description "DiffPair length tolerance verification status")
  (Value (DataType (dString)) (Status sVStatus sNoInherit sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair oResult))
  (Version "16.3")
)
( Attribute
  (Name DIFFP_PHASE_TOL_DYNAMIC_DRC)
  (Description "DiffPair length tolerance DRC object")
  (Value (DataType (dString)) (Status sActual sHidden sDRCVerify sDiffPairVerify sDelayRelated sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oResult))
  (Version "16.3")
)
( Attribute
  (Name DIFFP_MIN_SPACE)
  (Description "Minimum line spacing for DiffPair")
  (Value (DataType (dListDouble)) (ValueType vDiffPairLayer) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Objects (ValidObjects oDesign oECSet oPCSet oNetClass oNetGroup oDiffPair oXnet oNet oRegion oRegionClass))
  (PropertyToRestrict (fDiffPairMinusVerify DIFFP_PRIMARY_GAP DIFFP_NECK_GAP DIFFP_COUPLED_MINUS))
  (Version "15.0")
  (Tiering (Tier tL) (Options tTotalEtch))
)
( Attribute
  (Name DIFFP_MIN_SPACE_ACTUAL)
  (Description "DiffPair minimum line to line spacing")
  (Value (DataType (dMinDouble)) (Units uDesign mil) (Status sActual sNoInherit sDRCVerify sDiffPairVerify sCMEditOnly))
  (Analysis (Pass "PASS (Actual not calculated)"))
  (Objects (ValidObjects oXnet oNet))
  (Version "15.0")
)
( Attribute
  (Name DIFFP_PRIMARY_GAP)
  (Description "DiffPair primary separation gap")
  (Value (DataType (dListDouble)) (ValueType vDiffPairLayer) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Analysis (Status sVerifyOnChange sDiffPairVerify))
  (Objects (ValidObjects oDesign oECSet oPCSet oNetClass oNetGroup oDiffPair oXnet oNet oRegion oRegionClass))
  (PropertyToRestrict (fDiffPairPlusVerify DIFFP_MIN_SPACE DIFFP_COUPLED_MINUS DIFFP_NECK_GAP))
  (Version "15.0")
  (Tiering (Tier tL) (Options tTotalEtch))
)
( Attribute
  (Name DIFFP_PRIMARY_GAP_VMODE)
  (Description "Differential Pair verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases DIFFP_UNCOUPLED_LENGTH_VMODE DIFFP_PHASE_TOL_VMODE DIFFP_MIN_SPACE_VMODE)
  (Version "15.0")
)
( Attribute
  (Name MIN_LINE_WIDTH)
  (Description "Minimum line width")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vDiffPairLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oECSet oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (PropertyToRestrict (fMaxConstraintOrZero MAX_LINE_WIDTH))
  (Version "15.0")
)
( Attribute
  (Name MIN_LINE_WIDTH_VMODE)
  (Description "Minimum line width verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name MAX_LINE_WIDTH)
  (Description "Maximum line width")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vDiffPairLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (PropertyToRestrict (fMinConstraintOrZero MIN_LINE_WIDTH))
  (Version "16.0")
)
( Attribute
  (Name MAX_LINE_WIDTH_VMODE)
  (Description "Maximum line width verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name DIFFP_NECK_GAP)
  (Description "Neck gap if DiffPair segments reduce to the Neck width")
  (Value (DataType (dListDouble)) (ValueType vDiffPairLayer) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Analysis (Status sDiffPairVerify))
  (Objects (ValidObjects oDesign oECSet oPCSet oNetClass oNetGroup oDiffPair oXnet oNet oRegion oRegionClass))
  (RelatedProperties MIN_NECK_WIDTH DIFFP_COUPLED_PLUS DIFFP_COUPLED_MINUS DIFFP_PRIMARY_GAP MIN_LINE_WIDTH)
  (PropertyToRestrict (fDiffPairPlusVerify DIFFP_MIN_SPACE DIFFP_COUPLED_MINUS DIFFP_PRIMARY_GAP))
  (Version "15.0")
  (Tiering (Tier tL) (Options tTotalEtch))
)
( Attribute
  (Name MIN_NECK_WIDTH)
  (Description "Width which can be used to neck-through tight areas")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vDiffPairLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oECSet oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "15.0")
)
( Attribute
  (Name MAXIMUM_NECK_LENGTH)
  (Description "Length which can be used to neck-through tight areas")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oECSet oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name DIFFP_COUPLED_PLUS)
  (Description "DiffPair primary separation positive tolerance")
  (Value (DataType (dListDouble)) (ValueType vDiffPairLayer) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Analysis (Status sVerifyOnChange sDiffPairVerify))
  (Objects (ValidObjects oDesign oECSet oPCSet oNetClass oNetGroup oDiffPair oXnet oNet oRegion oRegionClass))
  (Version "15.0")
  (Tiering (Tier tL) (Options tTotalEtch))
)
( Attribute
  (Name DIFFP_COUPLED_MINUS)
  (Description "DiffPair primary separation negative tolerance")
  (Value (DataType (dListDouble)) (ValueType vDiffPairLayer) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly) (Category cBubble))
  (Analysis (Status sVerifyOnChange sDiffPairVerify))
  (Objects (ValidObjects oDesign oECSet oPCSet oNetClass oNetGroup oDiffPair oXnet oNet oRegion oRegionClass))
  (PropertyToRestrict (fDiffPairMinusVerify DIFFP_PRIMARY_GAP DIFFP_NECK_GAP DIFFP_MIN_SPACE))
  (Version "15.0")
  (Tiering (Tier tL) (Options tTotalEtch))
)

; GENERIC ATTRIBUTES FOR LENGTH/TIME
; ==================================
( Attribute
  (Name CM_OBJECT_LENGTH)
  (Description "Length of an object")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair oResult))
  (Analysis (MeasureName Length) )
)
( Attribute
  (Name CM_OBJECT_PROPDELAY)
  (Description "Delay of an object")
  (Value (DataType (dDouble)) (Units uTime ns) (Status sActual sNoInherit sCMEditOnly))
  (Objects (ValidObjects oPinPair oResult))
  (Analysis (MeasureName PropDelay) )
)

; DRAWING ATTRIBUTES
; ==================
( Attribute
   (Name DESIGN_UNITS)
   (Description "Defines the current units of measurement for coordinate and distance data")
   (Value (DataType (dListInteger)) (Units uPrecision none) (Status sProperty sDrawing sNoUnitStr sCMEditOnly))
   (Objects (ValidObjects oSystem oDesign))
)
( Attribute
  (Name DRAWING_EXTENTS)
  (Description "Extents of the drawing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sDrawing sNoUnitStr sCMEditOnly))
  (Objects (ValidObjects oDesign))
  (Version "16.0")
)
( Attribute
  (Name DRAWING_LOWER_LEFT)
  (Description "Lower-left location of the drawing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Status sProperty sDrawing sNoUnitStr sCMEditOnly))
  (Objects (ValidObjects oDesign))
  (Version "16.0")
)

; MISC ATTRIBUTES
; ===============

; sNoInherit for TOPOLOGY_TEMPLATE_REVISION block to put info into Constraint Audit as overrides.
( Attribute
  (Name TOPOLOGY_TEMPLATE_REVISION)
  (Description "Applied template or electrical CSet revision number")
  (Value (DataType (dString)) (Status sProperty sNoInherit sCMEditOnly))
  (Objects (ValidObjects oECSet oXnet oNet))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name TOPOLOGY_TEMPLATE)
  (Description "Topology template name")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
  (Domains dElectrical)  
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name ASSIGN_TOPOLOGY)
  (Description "Topology template name from schematic")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oXnet oNet))
  (Domains dElectrical)  
  (Tiering (Tier tXL) (Options tHighSpeed))
)
(Attribute
  (Name CDS_XNET_NAME)
  (Description "Property to select or ignore Net for XNet name.")
  (Value (DataType (dEnum SELECT IGNORE)) (Status sProperty sNoEditor))
  (Objects (ValidObjects oNet))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
(Attribute
  (Name CDS_EXPORT_CONTENTS_MASK)
  (Description "Data defining contents of last Export\Physical run.")
  (Value (DataType (dInteger)) (Status sNoEditor sNoFlow sProperty sNoMerge sWriteCMDBSaveOnly))
  (Objects (ValidObjects oDesign))
)
(Attribute
  (Name CDS_EDIT_PNS_STATUS)
  (Description "Physical and Spacing Edit status in Front-end.")
  (Value (DataType (dInteger)) (Status sNoEditor sNoFlow sProperty sNoMerge sWriteCMDBSaveOnly))
  (Objects (ValidObjects oDesign))
)

; UI/CONTROL ATTRIBUTES
; =====================
( Attribute
  (Name RIPUP_ETCH)
  (Description "Enable ripup etch during electrical CSet apply")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name ECSET_MAPPING_ERROR)
  (Description "Electrical CSet apply mapping error")
  (Value (DataType (dString)) (Status sControl sActual sECSetMappingVerify sNoInherit sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name ECSET_MAPPING_ERROR_MARGIN)
  (Description "Electrical CSet apply mapping margin")
  (Value (DataType (dDouble)) (Status sControl sResult sECSetMappingVerify sNoInherit sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name DRC_UNROUTED_MINPROP)
  (Description "Enable DRC for Min Prop Delay when PinPair is not fully routed")
  (Value (DataType (dEnum Y N)) (Status sControl sVMode))
  (Objects (ValidObjects oSystem oDesign ))
  (Tiering (Tier tBase))
)
( Attribute
  (Name DRC_UNROUTED_RELPROP)
  (Description "Enable DRC for Relative Delay when PinPair is not fully routed")
  (Value (DataType (dEnum Y N)) (Status sControl sVMode))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tBase))
)
( Attribute
  (Name AUTOMATIC_TOPOLOGY_UPDATE)
  (Description "Update topology immediately on electrical CSet changes")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name OVERRIDE_LOCAL_CONSTRAINTS)
  (Description "Replace local constraints during an ECSet apply")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name TOPOLOGY_TEMPLATE_EXTRACT_MODE)
  (Description "Controls what is extracted from a Net to create a top file")
  (Value (DataType (dLong)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name ONLINEFORMULAS_ENABLED)
  (Description "Enable online formula calculations")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name RUN_ANALYSIS_ENABLED)
  (Description "Enable analysis of empty cells during formula calculations")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name FTS_MODE)
  (Description "Fast/Typical/Slow simulation mode")
  (Value (DataType (dListEnum Fast Typical Slow Fast/Slow Slow/Fast)) (ValueType vEnum) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
)
( Attribute
  (Name SIM_DATA)
  (Description "Simulation data type")
  (Value (DataType (dEnum Reflection ComprehensiveOdd ComprehensiveEven ComprehensiveStatic)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name SIM_MEASUREMENT)
  (Description "Simulation measurement type")
  (Value (DataType (dEnum Pulse Rise/Fall Custom)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name AGGRESSOR_SWITCH_MODE)
  (Description "Xtalk aggressor switch mode")
  (Value (DataType (dEnum Odd Even Odd/Even)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name AGGRESSOR_DRIVER_SELECTION)
  (Description "Xtalk aggressor driver selection")
  (Value (DataType (dEnum FastestDriver AllDrivers)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name XTALK_TIMING_WINDOWS)
  (Description "Xtalk timing windows")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name CREATE_WAVEFORMS)
  (Description "Save waveforms")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name CREATE_CIRCUIT)
  (Description "Save circuit file")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name USE_CUSTOM_STIMULUS)
  (Description "Use custom stimulus for custom measurements")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name CREATE_PLANEMODELS)
  (Description "Save plane modeling")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name ONLINE_DRC)
  (Description "On-line DRC")
  (Value (DataType (dEnum Y N R)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
)
( Attribute
  (Name DRC_IS_UPTODATE)
  (Description "DRC scope status")
  (Value (DataType (dBoolean)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
)

;
; // PS (6/13/2003) PIN_DELAY:
;
( Attribute
  (Name PIN_DELAY)
  (Description "Pin delay is the value (length or time) from the die of the component to the point on the board")
  (Value (DataType (dString)) (Units uTimeLength mil) (Status sProperty sAskAppForDataOnce sVerifyOnChange sForceOverrideAudit sUpdateDelay sCheckVMode sCMEditOnly))
  (Objects (ValidObjects oPin oPinPair oResult))
  (Version "15.2")
  (Domains dElectrical)  
)
( Attribute
  (Name PIN_DELAY_PVF )
  (Description "PinDelay Propagation Velocity Factor")
  (Value (DataType (dString)) (Units uVelocity m/s) (Status sControl sVMode sVerifyOnChange sUpdateDelay sCheckVMode))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name PIN_DELAY_ENABLED )
  (Description "Include PinDelay in all Propagation Delays and Differential Pair Phase checks")
  (Value (DataType (dEnum Y N)) (Status sControl sVerifyOnChange sVMode sUpdateDelay))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases PIN_DELAY_VMODE PIN_DELAY_PVF_VMODE)
  (Tiering (Tier tBase))
)

;
; // PS (9/23/2003) VIA_Z
;
( Attribute
  (Name VIA_Z_PVF )
  (Description "Z Axis Delay Propagation Velocity Factor")
  (Value (DataType (dString)) (Units uVelocity m/s) (Status sControl sVMode sVerifyOnChange))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name VIA_Z_ENABLED )
  (Description "Include Z Axis Delay in all Propagation Delays and Differential Pair Phase checks")
  (Value (DataType (dEnum Y N)) (Status sControl sVMode sVerifyOnChange))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases VIA_Z_PVF_VMODE)
  (Tiering (Tier tBase))
)
( Attribute
  (Name SAME_NET_XTALK_ENABLED )
  (Description "Include same net etch in Xtalk and parallelism checks")
  (Value (DataType (dEnum Y N)) (Status sControl sVMode))
  (Objects (ValidObjects oSystem oDesign))
  (Tiering (Tier tBase))
)
( Attribute
  (Name DIFFP_USES_PROPERTIES)
  (Description "Diff pair overrides take precedence over region constraints")
  (Value (DataType (dEnum Y N)) (Status sControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
  (Tiering (Tier tBase))
)

; HIDDEN ATTRIBUTES (CM-only)
; ===========================
( Attribute
  (Name FULLY_ROUTED)
  (Description "If defined, the object is fully routed.")
  (Value (DataType (dChar)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oXnet oNet oPinPair))
)
( Attribute
  (Name ECSET_PINUSAGE)
  (Description "Pin usage")
  (Value (DataType (dInteger)) (Status sHidden sCMEditOnly))
  (Objects (ValidObjects oECSetPin))
)
( Attribute
  (Name ELECTRICAL_CONSTRAINT_SET)
  (Description "Electrical Constraint Set reference")
  (Value (DataType (dEnum nil)) (ValueType vEnumSpecial) (Status sConstraint sCMEditOnly sNoMerge sWriteCMDBSaveOnly sRelation) (Category cBubble))
  (Objects (ValidObjects oNetGroup oNetClass oBus oDiffPair oXnet oNet))
  (RelatedProperties ECSET_MAPPING_ERROR ECSET_MAPPING_ERROR_MARGIN)
  (Tiering (Tier tL) (Options tTotalEtch))
  (Domains dElectrical)
)
( Attribute
  (Name PHYSICAL_CONSTRAINT_SET)
  (Description "Physical Constraint Set reference")
  (Value (DataType (dEnum nil)) (ValueType vEnumSpecial) (Status sConstraint sCMEditOnly sNoMerge sWriteCMDBSaveOnly sRelation))
  (Objects (ValidObjects oDesign oRegion oNetClass oNetGroup oRegionClass oBus oDiffPair oXnet oNet oPinPair))
  (Domains dPhysical)  
)
( Attribute
  (Name SPACING_CONSTRAINT_SET)
  (Description "Spacing Constraint Set reference")
  (Value (DataType (dEnum nil)) (ValueType vEnumSpecial) (Status sConstraint sCMEditOnly sNoMerge sWriteCMDBSaveOnly sRelation))
  (Objects (ValidObjects oDesign oRegion oNetClass oNetGroup oNetClassClass oRegionClass oRegionClassClass oBus oDiffPair oXnet oNet oPinPair))
  (Domains dSpacing)  
)
( Attribute
  (Name SAME_NET_SPACING_CONSTRAINT_SET)
  (Description "Same Net Spacing Constraint Set reference")
  (Value (DataType (dEnum nil)) (ValueType vEnumSpecial) (Status sConstraint sCMEditOnly sNoMerge sWriteCMDBSaveOnly sRelation))
  (Objects (ValidObjects oDesign oRegion oNetClass oNetGroup oRegionClass oBus oDiffPair oXnet oNet oPinPair))
  (Domains dSameNetSpacing)  
)
( Attribute
  (Name ASSEMBLY_CONSTRAINT_SET)
  (Description "Assembly Constraint Set reference")
  (Value (DataType (dEnum nil)) (ValueType vEnumSpecial) (Status sConstraint sCMEditOnly sNoMerge sWriteCMDBSaveOnly sRelation))
  (Objects (ValidObjects oDesign oIODie oWireProfile oPartClass oClassClass))
  (Domains dAssembly)  
)

( Attribute
  (Name CANONICAL_NAME)
  (Description "Canonical name of an object")
  (Value (DataType (dString)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oDesign oBlock oNetClass oNetGroup oBus oDiffPair oXnet oGate oNet oPin oPinPair))
)

; Allegro Net Properties
; ======================

; Net>General Properties
; ==================

; Obsolete, replaced by net classes -->
( Attribute
  (Name NET_PHYSICAL_TYPE)
  (Description "Name of physical constraint set to apply (NET_PHYSICAL_TYPE)")
  (Value (DataType (dString)) (ValueType vEditOrPickFromList) (Status sProperty sUpperCaseValue))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name NET_SPACING_TYPE)
  (Description "Name of spacing constraint set to apply (NET_SPACING_TYPE)")
  (Value (DataType (dString)) (ValueType vEditOrPickFromList) (Status sProperty sUpperCaseValue))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
; <-- Obsolete, replaced by net classes

( Attribute
  (Name VOLTAGE)
  (Description "Voltage of a DC net or operating voltage of a gate")
  (Value (DataType (dString)) (Units uVoltage V) (Status sProperty sPackage sOnlyREDSValidation sIgnoreConversion sNoUnitStr) (Category cBubble))
  (Objects (ValidObjects oBus oNet oPart oGate) (NoPackage oBus oNet))
  (Version "15.2")
  (Domains dElectrical)  
)
( Attribute
  (Name WEIGHT)
  (Description "Auto-placement value (0 to 100) indicating importance of keeping this net as short as possible (WEIGHT)")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name NO_RAT)
  (Description "Whether to display ratsnesting for this net (NO_RAT)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name ROUTE_PRIORITY)
  (Description "Net routing priority (ROUTE_PRIORITY)")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name ROUTE_TO_SHAPE)
  (Description "Whether net can be routed to a shape (ROUTE_TO_SHAPE)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name FIXED)
  (Description "Whether an object can be moved, deleted, ripped up, glossed (FIXED)")
  (Value (DataType (dBoolean)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oNet oPart oPin oIODriver oIOTile) (NoPackage oNet))
  (Version "15.2")
)
( Attribute
  (Name NO_ROUTE)
  (Description "Whether missing connections on this net should be routed (NO_ROUTE)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oPart oNet))
  (Version "15.2")
)
( Attribute
  (Name NO_RIPUP)
  (Description "Whether router can rip up etch on this net (NO_RIPUP)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name NO_PIN_ESCAPE)
  (Description "Whether router can place pin escapes on this net (NO_PIN_ESCAPE)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet oPart oPin))
  (Version "15.2")
)
( Attribute
  (Name NO_TEST)
  (Description "Whether test points may be generated for this net (NO_TEST)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name TESTPOINT_QUANTITY)
  (Description "The desired number of testpoints on this net (TESTPOINT_QUANTITY)")
  (Value (DataType (dInteger)) (Range (Min 0)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name PROBE_NUMBER)
  (Description "The test probe to be used for this net (PROBE_NUMBER)")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oNet oGate))
  (Version "15.2")
)
( Attribute
  (Name BACKDRILL_MAX_PTH_STUB)
  (Description "Maximum plated thru hole stub length allowed on this net with backdrilling (BACKDRILL_MAX_PTH_STUB)")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.7")
  (Tiering (Tier tBase))
)
( Attribute
  (Name NO_GLOSS)
  (Description "Whether net should be glossed (NO_GLOSS)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name SHIELD_NET)
  (Description "Net to use as a shield for this one (SHIELD_NET)")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name SHIELD_TYPE)
  (Description "Type (parallel, tandem, coax) of the shield net (SHIELD_TYPE)")
  (Value (DataType (dEnum PARALLEL TANDEM COAX)) (ValueType vEnum) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNet))
  (Version "15.2")
)
( Attribute
  (Name UNUSED_PADS_IGNORE)
  (Description "Pads on this net are to be ignored by dynamic unused pads suppression (UNUSED_PADS_IGNORE)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "16.2")
)
( Attribute
  (Name NO_DIFF_PAIR)
  (Description "Exclude Xnet/Net when automatically creating model-defined DiffPairs")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oXnet oNet))
  (Version "16.3")
)
( Attribute
  (Name JUMPER_LIST)
  (Description "Colon delimited list of jumpers")
  (Value (DataType (dString)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oDesign))
  (Version "16.3")
)
( Attribute
  (Name RETAIN_NET_ON_VIAS)
  (Description "Vias will retain original Net if the Net is renamed.")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Aliases STICKY_VIAS)
  (Version "16.3")
)
; ============================================
; TDD Properties
; ==============================================
; TDD Tool Generated Properties Not shown in CM
; ==============================================
( Attribute
  (Name TERMINATION)
  (Description "Generates when a termination is applied")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate oPin))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name TERM_IDENT)
  (Description "Generated when a termination is applied")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate oPin))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name PARENT_PPT_PART)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name PARENT_PPT)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name PARENT_PART_TYPE)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name NAME_OF_PART)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name LONG_PART_NAME)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name PARENT_CHIPS_PHYS_PART)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name CDS_PART_NAME)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name CDS_ERR_LOCATION)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sPrefix sSuffix sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name CDS_ERR_PHYS_NET_NAME)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name DIFFERENTIAL_PAIR)
  (Description "Property used for Concept-CM synchronization")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoFlow))
  (Objects (ValidObjects oNet))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
(Attribute
  (Name CDS_DIFFPAIR_NAME)
  (Description "Temporary property for new name of Diff Pair in case there is a Diff Pair rename triggered by CM.")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoFlow))
  (Objects (ValidObjects oDiffPair))
)
( Attribute
  (Name CDS_PDV_INT_SYM_GNAME)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoFlow sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name CDS_LIB)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name CDS_LOCATION)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name SEC)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sReadOnly sNoInherit sPackage))
  (Objects (ValidObjects oGate oPin))
  (Version "15.5")
)
( Attribute
  (Name CDS_SEC)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oGate oPin))
  (Version "15.5")
)
( Attribute
  (Name SCHEMATIC_GROUP)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oGate))
)
( Attribute
  (Name CDS_PHYS_NET_NAME)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoAliasMerge sPackage))
  (Objects (ValidObjects oNet oBus))
  (Version "15.5")
)
( Attribute
  (Name PNN)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oBus oNet))
  (Version "15.5")
)
( Attribute
  (Name PRIM_FILE)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name CHIPS_PART_NAME)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name DS_MAP_VALUE)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name DS_MAP_PROPNAME)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name DLY)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate oPin))
  (Version "15.5")
)
( Attribute
  (Name SUBDESIGN_PREFIX)
  (Description "Generated by PXL on blocks added with block prefix option")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oBlock))
  (Aliases BLOCK_PREFIX)
  (Version "15.5")
)
( Attribute
  (Name SUBDESIGN_SUFFIX)
  (Description "Generated by PXL on blocks added with block suffix option")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oBlock))
  (Aliases BLOCK_SUFFIX)
  (Version "15.5")
)
( Attribute
  (Name RANGE_START)
  (Description "Generated by PXL on blocks added with block added with range option & specifies starting range")
  (Value (DataType (dInteger)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oBlock oDesign))
  (Version "15.5")
)
( Attribute
  (Name RANGE_END)
  (Description "Generated by PXL on blocks added with block added with range option & specifies ending range")
  (Value (DataType (dInteger)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oBlock oDesign))
  (Version "15.5")
)
( Attribute
  (Name CDS_FUNC_IDENT)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "16.0")
)
( Attribute
  (Name CDS_PARENT_FUNC_IDENT)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "16.0")
)
( Attribute
  (Name CDS_DEFINE_BODY_PAGE)
  (Description "Page where Define body is processed from")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oDesign oBlock oGate))
  (Version "16.5")  
)
( Attribute
  (Name CDS_VHDL_DECS_BODY_PAGE)
  (Description "Page where VHDL_DECS body is processed from")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oDesign oBlock oGate))
  (Version "16.5")  
)
( Attribute
  (Name CDS_DRAWING_BODY_PAGE)
  (Description "Page where DRAWING body is processed from")
  (Value (DataType (dString))(Status sProperty))
  (Objects (ValidObjects oDesign oBlock oGate))
  (Version "16.5")  
)
( Attribute 
  (Name SYM_NAME) 
  (Description "Functional name of the symbol") 
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit)) 
  (Objects (ValidObjects oGate oBlock)) 
  (Version "16.6")  
) 

;------------------------------------
; GATE - Physical Properties Workbook
; -----------------------------------
( Attribute
  (Name ALT_SYMBOLS)
  (Description "Used to specify a list of alternate package symbol names")
  (Value (DataType (dString)) (Status sProperty sPackage sPackageCreatePart sNoInherit sReadOnly))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name EMC_COMP_TYPE)
  (Description "Specifies the component type")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oPart oGate))
  (Version "15.5")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name EMC_CRITICAL_IC)
  (Description "")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oPart oGate))
  (Version "15.5")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name GROUP)
  (Description "Identifies schematic instances that are to be packaged together")
  (Value (DataType (dString)) (Status sProperty sPackage sPackageSameValue))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name HEIGHT)
  (Description "Specifies the package height")
  (Value (DataType (dString)) (Status sProperty sPackageCreatePart sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name JEDEC_TYPE)
  (Description "Specifies the footprint to be used in the Allegro for component in logical netlist")
  (Value (DataType (dString)) (Status sProperty sPackage sPackageCreatePart sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name ROOM)
  (Description "Instances with same room value are to be packaged and placed together")
  (Value (DataType (dString)) (Status sProperty sPackage sPackageSameValue))
  (Objects (ValidObjects oPart oGate oBlock) (NoPackageNonFlow oPart))
  (Version "15.5")
)
( Attribute
  (Name SIGNAL_MODEL)
  (Description "Defines electrical, I/O models and package parasitics model")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage sPackageSameValue sNoInherit))
  (Objects (ValidObjects oPartDefn oPart oGate))
  (Version "15.5")
)
( Attribute
  (Name DEFAULT_SIGNAL_MODEL)
  (Description "Defines electrical, I/O models and package parasitics model")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage sPackageSameValue sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name VOLT_TEMP_SIGNAL_MODEL)
  (Description "Defines electrical, I/O models and package parasitics model")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage sPackageSameValue sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name TOL)
  (Description "Percent tolerance used by Allegro/APD GenRad interface to prepare .ckt file")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name VIA_LIST)
  (Description "A list of via names that can be used for connections in this net")
  (Value (DataType (dUtlStringArray)) (ValueType vViaList) (MaxLength Unlimited) (Status sProperty sOnlyREDSValidation))
  (Objects (ValidObjects oRegion oNetClass oNetGroup oRegionClass oPCSet oDesign oBus oDiffPair oXnet oNet oPinPair))
  (PropertyToRestrict (fViaListFormatCheck VIA_LIST))
  (Version "15.5")    
)
( Attribute
  (Name ALLOW_CONNECT)
  (Description "Allows different types of outputs to be connected without producing errors")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate oBus oNet oPin) (NoPackage oBus oNet))
  (Version "15.5")
)
( Attribute
  (Name BOM_IGNORE)
  (Description "Component instances having this property will not be displayed in the Bill of Materials report")
  (Value (DataType (dString)) (Status sProperty sPackageSameValue sNoInherit))
  (Objects (ValidObjects oPart oGate) (NoPackageNonFlow oPart))
  (Version "15.5")
)
( Attribute
  (Name BLOCK)
  (Description "Attached to the origin of a block")
  (Value (DataType (dString)) (Status sProperty sNoEditor))
  (Objects (ValidObjects oBlock))
  (Version "15.5")
)
( Attribute
  (Name CDS_NOT_ON_SYM)
  (Description "Added on pins that belong to split parts that are not initiated on the schematic")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oPin))
  (Version "15.5")
)
( Attribute
  (Name COMP_NAME)
  (Description "Name of the alternate physical part")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name COMP_NAME_SUFFIX)
  (Description "Appended to the physical part name")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name HAS_FIXED_SIZE)
  (Description "Identifies symbols with a fixed size")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name SIZE)
  (Description "It identifies those symbols that have a size")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name LAST_MODIFIED)
  (Description "Date and time of the last save")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name LOCATION)
  (Description "Controls packaging by assigning a particular physical part to a logical component")
  (Value (DataType (dString)) (Status sProperty sPrefix sSuffix sPackage sReadOnly sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name MERGE_NC_PINS)
  (Description "Merges the NC_PINS in the schematic instance or in the chips.prt or ptf files")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sPackageCreatePart sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name MERGE_POWER_PINS)
  (Description "Add pins to an existing POWER_PINS or NC_PINS property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sPackageCreatePart sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name NC_PINS)
  (Description "Specify pins which are present on a physical package but do not have any logical connections")
  (Value (DataType (dUtlStringArray)) (Delimiter ",") (Status sProperty sReadOnly sPackage sPackageCreatePart sNoInherit))  
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name NEEDS_NO_SIZE)
  (Description "Identify those symbols that do not need SIZE property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name NO_BACKANNOTATE)
  (Description "Used when user does not want properties updated in the schematic")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name PATH)
  (Description "Concept add this property on gates")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name PART_NUMBER)
  (Description "")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name PART_NAME)
  (Description "Specifies the part name")
  (Value (DataType (dString)) (Status sProperty sPackage sReadOnly sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name PACK_TYPE)
  (Description "Specifies the type of package used for a part")
  (Value (DataType (dString)) (Status sProperty sPackage sReadOnly sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name PACK_IGNORE)
  (Description "Specifies the type of package used for a part")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name PACK_SHORT)
  (Description "Specifies the shorting of pins of a part")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name PHYS_DES_PREFIX)
  (Description "Specifies the ref des prefix for the default PXL naming pattern")
  (Value (DataType (dString)) (Status sProperty sPackage sReadOnly))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name POWER_GROUP)
  (Description "Modifies the POWER_PINS property at any given level")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage sPackageCreatePart sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name POWER_PINS)
  (Description "Specifies power and ground pins that exist on the physical part but are not shown on the schematic symbol")
  (Value (DataType (dUtlStringArray)) (Delimiter ";") (Status sProperty sReadOnly sPackage sPackageCreatePart sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name PINCOUNT)
  (Description "Specifies pin count")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage sPackageCreatePart sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name SPLIT_INST)
  (Description "Added on all split parts of a device")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name SPLIT_INST_NAME)
  (Description "Add on all split parts that have to be merged into a single instance in simulation netlist")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name SUBDESIGN_MASTER)
  (Description "Identifies which instance in top level design will be used by GEN_SUBDESIGN directive to generate subdesign state files")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oBlock))
  (Version "15.5")
)
( Attribute
  (Name VALUE)
  (Description "Used by the Allegro/APD interface to prepare the .ckt file")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name VER)
  (Description "Concept (tool) generated property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name ROT)
  (Description "Concept (tool) generated property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name XY)
  (Description "Concept (tool) generated property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "15.5")
)
( Attribute
  (Name REUSE_INSTANCE)
  (Description "Package property")
  (Value (DataType (dString)) (Status sPackage sReadOnly sPackageSameValueOnly))  
  (Objects (ValidObjects oPart oBlock oGate))
  (Version "15.5")
)
( Attribute
  (Name REUSE_ID)
  (Description "Package property")
  (Value (DataType (dString)) (Status sPackage sReadOnly sPackageSameValue sNoInherit))
  (Objects (ValidObjects oPart oBlock oGate))
  (Version "15.5")
)
( Attribute
  (Name REUSE_NAME)
  (Description "Package property")
  (Value (DataType (dString)) (Status sPackage sReadOnly sPackageSameValue))
  (Objects (ValidObjects oPart oBlock oGate))
  (Version "15.5")
)
( Attribute
  (Name VOLT_TEMP_MODEL)
  (Description "The voltage temperature model for the pin")
  (Value (DataType (dString)) (Status sProperty sPackage sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "15.5")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name REF_DES_FOR_ASSIGN)
  (Description "The preferred reference designator when assigning gate (REF_DES_FOR_ASSIGN)")
  (Value (DataType (dString)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oGate))
  (Version "16.0")
)
( Attribute
  (Name REF_DES_PATTERN)
  (Description "Used for specifying reference designator pattern on instances of block")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "16.5")
)
( Attribute
  (Name SLOTNAME)
  (Description "The preferred slot name when assigning gate (SLOTNAME)")
  (Value (DataType (dString)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oGate))
  (Version "16.0")
)
; sReadOnly in BE
( Attribute
  (Name SWAP_GROUP)
  (Description "A group for swapping (SWAP_GROUP)")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oGate))
  (Version "16.0")
)
( Attribute
  (Name SCHEMATIC_PLACE_ORDER)
  (Description "Recommended placement order in a generated schematic for instances belonging to the same group")
  (Value (DataType (dInteger)) (Status sProperty sPackage sNoFlow sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "16.0")
)
( Attribute
  (Name IGNORE_IN_DOCSCHGEN)
  (Description "Ignore instances while generating schematic so that they don't appear")
  (Value (DataType (dInteger)) (Status sProperty sPackage sNoFlow sNoInherit))
  (Objects (ValidObjects oGate))
  (Version "16.0")
)
( Attribute
  (Name ALLOW_CONN_SWAP)
  (Description "Allows connection to be swapped if component Pin are swapped")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty sPackage sNoFlow))
  (Objects (ValidObjects oGate))
  (Version "16.2")
)
( Attribute
  (Name PHYS_PAGE)
  (Description "Concept (tool) generated property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit sPackage))
  (Objects (ValidObjects oGate oBlock))
  (Version "16.5")
)
( Attribute
  (Name USE1)
  (Description "Concept (tool) generated property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit))
  (Objects (ValidObjects oGate oBlock))
  (Version "16.5")
)
( Attribute
  (Name USE2)
  (Description "Concept (tool) generated property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit))
  (Objects (ValidObjects oGate oBlock))
  (Version "16.5")
)
( Attribute
  (Name LIBRARY1)
  (Description "Concept (tool) generated property")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoInherit))
  (Objects (ValidObjects oGate oBlock))
  (Version "16.5")
)
( Attribute
  (Name PSPICE_LOCATION)
  (Description "Designates an identifier to instances for simulation flow")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage sNoInherit))
  (Objects (ValidObjects oGate oBlock))
  (Version "16.5")
)
;-----------------------------------
; PARTS - Part Properties workbook
; ----------------------------------
( Attribute
  (Name MAX_POWER_DISS)
  (Description "The power dissipation for the part (MAX_POWER_DISS)")
  (Value (DataType (dString)) (Status sProperty sAskAppForDataOnce sPackage))
  (Objects (ValidObjects oPart oGate) (NoPackageNonFlow oPart))
  (Version "16.0")
)
( Attribute
  (Name MAX_POWER_DISSIPATION)
  (Description "The power dissipation for the part (MAX_POWER_DISSIPATION)")
  (Value (DataType (dString)) (Units uPower W) (Status sProperty sAskAppForDataOnce sPackage))
  (Objects (ValidObjects oPart oGate) (NoPackageNonFlow oPart))
  (Version "16.0")
)
( Attribute
  (Name PLACE_TAG)
  (Description "The placement tag for the part (PLACE_TAG)")
  (Value (DataType (dBoolean)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
( Attribute
  (Name COMPONENT_WEIGHT)
  (Description "The component weighting for placement (COMPONENT_WEIGHT)")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oPart oGate) (NoPackageNonFlow oPart))
  (Version "16.0")
)
; sReadOnly in BE
( Attribute
  (Name FIX_ALL)
  (Description "Disable all swapping for gates/component (FIX_ALL)")
  (Value (DataType (dBoolean)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
; sReadOnly in BE
( Attribute
  (Name NO_SWAP_COMP)
  (Description "Disable swapping for component (NO_SWAP_COMP)")
  (Value (DataType (dBoolean)) (Status sProperty sReadOnly sNoFlow))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
; sReadOnly in BE
( Attribute
  (Name NO_SWAP_GATE)
  (Description "Disable swapping of gates (NO_SWAP_GATE)")
  (Value (DataType (dBoolean)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oPart oGate))
  (Version "16.0")
)
; sReadOnly in BE
( Attribute
  (Name NO_SWAP_GATE_EXT)
  (Description "Extension property to disable swapping of gates (NO_SWAP_GATE_EXT)")
  (Value (DataType (dBoolean)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oPart oGate))
  (Version "16.0")
)
; sReadOnly in BE
( Attribute
  (Name NO_SWAP_PIN)
  (Description "Disable swapping of pins (NO_SWAP_PIN)")
  (Value (DataType (dBoolean)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oPart oGate oPin))
  (Version "16.0")
)
( Attribute
  (Name J_TEMPERATURE)
  (Description "Component junction temperature (J_TEMPERATURE)")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oPart))
  (Version "16.0")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name HARD_LOCATION)
  (Description "Lock component/gate location (HARD_LOCATION)")
  (Value (DataType (dBoolean)) (Status sProperty sPackage))
  (Objects (ValidObjects oBlock oPart oGate))
  (Version "16.0")
)
( Attribute
  (Name AUTO_RENAME)
  (Description "Enable automatic renaming for components (AUTO_RENAME)")
  (Value (DataType (dBoolean)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
( Attribute
  (Name PIN_ESCAPE)
  (Description "Enable pin escapes on component/pins (PIN_ESCAPE)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oPart oPin))
  (Version "16.0")
)
( Attribute
  (Name DENSE_COMPONENT)
  (Description "Flag dense components (DENSE_COMPONENT)")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
( Attribute
  (Name AUTO_GENERATED_TERM)
  (Description "Automatically generated termination for components (AUTO_GENERATED_TERM)")
  (Value (DataType (dBoolean)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPart))
  (Version "16.0")
  (Tiering (Tier tBase))
)
;( Attribute
; (Name LOCKED)
;  (Description "Lock an object (LOCKED)")
;  (Value (DataType (dBoolean)) (Status sProperty sNoFlow))
;  (Objects (ValidObjects oPart oPin))
;  (Version "16.0")
;)
( Attribute
  (Name THETA_JB)
  (Description "Theta value JB (THETA_JB)")
  (Value (DataType (dString)) (Units uThermalResistance degC/W) (Status sProperty sPackage sAskAppForDataOnce))
  (Objects (ValidObjects oPartDefn oPart))
  (Version "16.0")
)
( Attribute
  (Name THETA_JC)
  (Description "Theta value JC (THETA_JC)")
  (Value (DataType (dString)) (Units uThermalResistance degC/W) (Status sProperty sPackage sAskAppForDataOnce))
  (Objects (ValidObjects oPartDefn oPart))
  (Version "16.0")
)
( Attribute
  (Name COMMENT)
  (Description "Comment")
  (Value (DataType (dString)) (Status sProperty sNoInherit ))
  (Objects (ValidObjects oPart oGate oPin ))
  (Version "16.0")
)
( Attribute
  (Name ISRFELEMENT)
  (Description "Is RF Element")
  (Value (DataType (dLong)) (Status sProperty sPackage sNoFlow ))
  (Objects (ValidObjects oPart oGate))
  (Version "16.0")
)
( Attribute
  (Name RFELEMENTTYPE)
  (Description "RF Element Type")
  (Value (DataType (dLong)) (Status sProperty sPackage))
  (Objects (ValidObjects oPart oGate))
  (Version "16.0")
)
( Attribute
  (Name RF_TLINE)
  (Description "RF TLine")
  (Value (DataType (dString)) (Status sProperty ))
  (Objects (ValidObjects oPart oGate))
  (Version "16.0")
)
( Attribute
  (Name REUSE_ALT_MODULE)
  (Description "Reuse ALT Module")
  (Value (DataType (dString)) (Status sPackage sPackageSameValue))
  (Objects (ValidObjects oPart oGate oBlock))
  (Version "16.0")
)
( Attribute
  (Name REUSE_MODULE)
  (Description "Reuse Module")
  (Value (DataType (dString)) (Status sPackage sPackageSameValue))
  (Objects (ValidObjects oPart oGate oBlock))
  (Version "16.0")
)
( Attribute
  (Name REUSE_PID)
  (Description "Reuse PID")
  (Value (DataType (dLong)) (Status sPackage sReadOnly sPackageSameValue))
  (Objects (ValidObjects oPart oGate oBlock))
  (Version "16.0")
)
( Attribute
  (Name CDS_D_PART_COUNT)
  (Description "Parts Count")
  (Value (DataType (dLong)) (Status sReadOnly sDerivedData))
  (Objects (ValidObjects oPartDefn ))
  (Version "16.0")
)
( Attribute
  (Name CDS_D_SYMBOL_X)
  (Description "The object's origin's x-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
( Attribute
  (Name CDS_D_SYMBOL_Y)
  (Description "The object's origin's y-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
( Attribute
  (Name CDS_D_SYMBOL_ROTATION)
  (Description "The object's rotation angle.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
( Attribute
  (Name CDS_D_SYMBOL_MIRROR)
  (Description "The object's mirrored flag.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oPart))
  (Version "16.0")
)
( Attribute
  (Name CDS_D_SYMBOL_EMBEDDED_LAYER)
  (Description "The object's embedded layer name.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oPart))
  (Version "16.5")
)
( Attribute
  (Name CDS_D_SYMBOL_EMBEDDED_STATUS)
  (Description "The object's embedded status.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oPart))
  (Version "16.5")
)
( Attribute
  (Name CDS_D_SYMBOL_EMBEDDED_ATTACH)
  (Description "The object's embedded attach.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oPart))
  (Version "16.5")
)
( Attribute
  (Name EMB_VIA_CONNECT_PADSTACK)
  (Description "If a symbol is placed and does not contain a property EMB_VIA_CONNECT_PADSTACK, this will be used by default to replace PIN's padstack.")
  (Value (DataType (dString)) (Status sProperty sReadOnly))
  (Objects (ValidObjects oDesign))
  (Version "16.5")
)
( Attribute
  (Name CAVITY2LAYER_CLEARANCE)
  (Description "Defines a clearance or buffer that will be factored in when calculating a component height violation if embedded.")
  (Value (DataType (dDouble)) (Status sProperty sReadOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name MIN_CAVITY_GAP)
  (Description "Defines the minimum XY spacing between cavities before they will merge.")
  (Value (DataType (dDouble)) (Status sProperty sReadOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name PLACEBOUND2VIAKEEPOUT_EXPANSION)
  (Description "This will be used to create a cavity outline from PLACEBOUND if library symbol does not contain one. Changing this value will not impact already placed symbols.")
  (Value (DataType (dDouble)) (Status sProperty sReadOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name VIA_CONNECT_HEIGHT)
  (Description "Defines a constant for the gap between the ETCH layer and the component mounted in the dielectric.")
  (Value (DataType (dDouble)) (Status sProperty sReadOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name CAVITY2RTKEEPOUT_EXPANSION)
  (Description "This will be used to create a route keepout outline from cavity outline when the symbol protrudes through a layer.")
  (Value (DataType (dDouble)) (Status sProperty sReadOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
  (Tiering (Tier tTooHigh))
)
( Bundle
  (Name EMB_DESIGN_PARAMS)
  (RelatedProperties MIN_CAVITY_GAP CAVITY2LAYER_CLEARANCE VIA_CONNECT_HEIGHT PLACEBOUND2VIAKEEPOUT_EXPANSION CAVITY2RTKEEPOUT_EXPANSION)
)
( Attribute
  (Name EMBEDDED_PLACEMENT)
  (Description "A component's embedded placement requirement.")
  (Value (DataType (dEnum REQUIRED OPTIONAL EXTERNAL_ONLY)) (Status sProperty sPackage))
  (Objects (ValidObjects oPartDefn oPart oGate) (NoPackageNonFlow oPart))
  (Version "16.5")
  (Tiering (Tier tXL) (Options tMiniaturization))
)

;-----------------------------------
; PIN - Physical Properties workbook
; ----------------------------------
( Attribute
  (Name PIN_SIGNAL_MODEL)
  (Description "Pin level override for a buffer model used in signal integrity simulations")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oPin))
  (Version "15.5")
  (Domains dElectrical)  
)
( Attribute
  (Name NO_DRC)
  (Description "Disable DRC checking for this pin or via")
  (Value (DataType (dBoolean)) (Status sProperty sCMEditOnly sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "15.5")
)
( Attribute
  (Name PINUSE)
  (Description "Indicates the type of pin")
  (Value (DataType (dEnum UNSPEC POWER GROUND NC IN OUT BI TRI OCA OCL)) (Status sProperty sPackage))
  (Objects (ValidObjects oPin) (NoPackageNonFlow oPin))
  (Version "15.5")
  (Domains dElectrical)
)
( Attribute
  (Name PN)
  (Description "Assigns a physical pin number to a logical pin in the schematic")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oPin))
  (Version "15.5")
)
( Attribute
  (Name PIN_TYPE)
  (Description "Attach to a pin to indicate its pin type")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oPin))
  (Version "15.5")
)
( Attribute
  (Name CDS_PIN_TEXT)
  (Description "Property added for Import FPGA")
  (Value (DataType (dString)) (Status sProperty sNoEditor sNoFlow sPackage))
  (Objects (ValidObjects oPin))
  (Version "15.6")
)
( Attribute
  (Name DYN_THERMAL_CON_TYPE)
  (Description "Thermal connection type for dynamic shapes (DYN_THERMAL_CON_TYPE)")
  (Value (DataType (dEnum ORTHOGONAL DIAGONAL FULL_CONTACT 8_WAY NONE)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name DYN_THERMAL_BEST_FIT)
  (Description "Thermal connection best fit for dynamic shapes (DYN_THERMAL_BEST_FIT)")
  (Value (DataType (dListEnum TRUE FALSE)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name DYN_MIN_THERMAL_CONNS)
  (Description "Minimum thermal connections to dynamic shapes (DYN_MIN_THERMAL_CONNS)")
  (Value (DataType (dLong)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name DYN_MAX_THERMAL_CONNS)
  (Description "Maximum thermal connections to dynamic shapes (DYN_MAX_THERMAL_CONNS)")
  (Value (DataType (dLong)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name DYN_OVERSIZE_THERM_WIDTH)
  (Description "Oversized thermal trace width for dynamic shapes (DYN_OVERSIZE_THERM_WIDTH)")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name DYN_CLEARANCE_TYPE)
  (Description "Clearance type for dynamic shapes (DYN_CLEARANCE_TYPE)")
  (Value (DataType (dEnum DRC_VALUE ANTI_TERMAL NO_VOID)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name DYN_CLEARANCE_OVERSIZE)
  (Description "Clearance oversize for dynamic shapes (DYN_CLEARANCE_OVERSIZE)")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name DYN_FIXED_THERM_WIDTH)
  (Description "Fixed thermal trace width for dynamic shapes (DYN_FIXED_THERM_WIDTH)")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name NO_SHAPE_CONNECT)
  (Description "Do not connect to shapes (NO_SHAPE_CONNECT)")
  (Value (DataType (dBoolean)) (Status sProperty ))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name SUBNET_NAME)
  (Description "Subnet of Pin (SUBNET_NAME)")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oNet oPin))
  (Version "16.0")
  (Tiering (Tier tXL))
)
( Attribute
  (Name SHORTING_SCHEME)
  (Description "Name of shorting scheme (SHORTING_SCHEME)")
  (Value (DataType (dString)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Tiering (Tier tXL))
  (Version "16.0")
)
( Attribute
  (Name VOLTAGE_SOURCE_PIN)
  (Description "Voltage supply Pin (VOLTAGE_SOURCE_PIN)")
  (Value (DataType (dBoolean)) (Status sProperty ))
  (Objects (ValidObjects oPin))
  (Version "16.0")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name NO_VIA_CONNECT)
  (Description "Do not connect pin/via (NO_VIA_CONNECT)")
  (Value (DataType (dBoolean)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name NET_SHORT)
  (Description "Shorting Net for Pin\Via (NET_SHORT)")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oPin) (NoPackageNonFlow oPin))
  (Version "16.0")
)
( Attribute
  (Name ASSIGN_ROUTE_LAYER)
  (Description "Routing layer for Pin/Net (ASSIGN_ROUTE_LAYER)")
  (Value (DataType (dString)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oNet oPin))
  (Version "16.0")
)
( Attribute
  (Name DEGAS_NO_VOID)
  (Description "Degassing void required (DEGAS_NO_VOID)")
  (Value (DataType (dBoolean)) (Status sProperty sPackage))
  (Objects (ValidObjects oNet oPin) (NoPackage oNet) (NoPackageNonFlow oPin))
  (Version "16.0")
  (Tiering (Tier tBase))
)
( Attribute
  (Name BACKDRILL_EXCLUDE)
  (Description "Backdrill Exclude")
  (Value (DataType (dBoolean)) (Status sProperty sPackage))
  (Objects (ValidObjects oPin) (NoPackageNonFlow oPin))
  (Version "16.0")
  (Tiering (Tier tBase))
)
( Attribute
  (Name BACKDRILL_MIN_PIN_PTH)
  (Description "Backdrill Min Pin Plated Thru Hole")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oPin) (NoPackageNonFlow oPin))
  (Version "16.0")
  (Tiering (Tier tBase))
)
( Attribute
  (Name CDS_PARENT_PIN_SPACING)
  (Description "Parent Pin Spacing")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name IDF_OWNER)
  (Description "IDF Owner")
  (Value (DataType (dEnum ECAD MCAD UNOWNED)) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name LEAD_DIAMETER)
  (Description "Lead Diameter")
  (Value (DataType (dString)) (Units uTimeLength mil) (Status sProperty sNoFlow))
  (Objects (ValidObjects oPin))
  (Version "16.0")
)
( Attribute
  (Name NO_WIREBOND)
  (Description "No Wirebond")
  (Value (DataType (dBoolean)) (Status sProperty sPackage))
  (Objects (ValidObjects oPin) (NoPackageNonFlow oPin))
  (Version "16.0")
)
( Attribute
  (Name VIA_AT_SMD_FIT)
  (Description "Via at SMD Fit")
  (Value (DataType (dString)) (Status sProperty sPackage))
  (Objects (ValidObjects oPin) (NoPackageNonFlow oPin))
  (Version "16.0")
)
( Attribute
  (Name PIN_GROUP)
  (Description "Pin level property for defining pin groups")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPackage))
  (Objects (ValidObjects oPin))
  (Version "15.7")
)
;-----------------------------
; NET - Physical Properties workbook
; ----------------------------
( Attribute
  (Name ECL)
  (Description "Identifies a high speed net")
  (Value (DataType (dBoolean)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.5")
  (Tiering (Tier tBase))
)
( Attribute
  (Name EMC_CRITICAL_NET)
  (Description " ")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oNet))
  (Version "15.5")
  (Tiering (Tier tXL) (Options tHighSpeed))
)
( Attribute
  (Name MAKE_BASE)
  (Description "Used to declare the name of the signal as the base signal name for all its aliases or synonyms")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oBus oNet))
  (Version "15.5")
)
( Attribute
  (Name PHYS_NET_NAME)
  (Description "Generated by PXL for those logical nets that have their physical nets names different from their logical nets")
  (Value (DataType (dString)) (Status sProperty sReadOnly sPrefix sSuffix sPackage))
  (Objects (ValidObjects oNet oBus))
  (Version "15.5")
)
( Attribute
  (Name BUS_NAME)
  (Description "Generated by PXL for those logical buses that have their physical bus names different from their logical buses")
  (Value (DataType (dString)) (Status sProperty sPrefix sSuffix sPackage sNoEditor))
  (Objects (ValidObjects oBus oNet))
  (Version "15.5")
)
( Attribute
  (Name SIG_NAME)
  (Description "Specifies a net name")
  (Value (DataType (dString)) (Status sProperty sNoEditor sPackage))
  (Objects (ValidObjects oNet))
  (Version "15.5")
)
;===============================
; Simulation Properties
;===============================
( Attribute
  (Name REMOVE)
  (Description "Used either on bodies in the library or on instances of bodies in the schematic design")
  (Value (DataType (dString)) (Status sProperty sPackage sNoFlow))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name SIM_MAP_VIEW)
  (Description "Overrides the default map file viewlist specified in the simulation configuration")
  (Value (DataType (dString)) (Status sProperty sPackage sNoFlow))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name VERILOG_MODEL)
  (Description "Used to change the name of Verilog module generated or to select a specific MODEL entry in a Verilog map file")
  (Value (DataType (dString)) (Status sProperty sPackage sNoFlow))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
( Attribute
  (Name VHDL_INIT)
  (Description "Initial value of the signal for VHDL")
  (Value (DataType (dString)) (Status sProperty sPackage sNoFlow sCMEditOnly))
  (Objects (ValidObjects oPin oNet))
  (Version "15.5")
)
( Attribute
  (Name VHDL_MODEL)
  (Description "Used to change the name of the VHDL module generated or to select a specific MODEL entry in a VHDL map file")
  (Value (DataType (dString)) (Status sProperty sPackage sNoFlow))
  (Objects (ValidObjects oGate))
  (Version "15.5")
)
;=====================================================================================
; I/O BUFFER SEQUENCING - DRIVER ATTRIBUTES
; =========================================
( Attribute
  (Name IO_TYPE)
  (Description "The type of object (Die, Tile, Driver...)")
  (Value (DataType (dEnum Die Tile Driver)) (ValueType vEnum) (Status sActual sReadOnly))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name LEFDEF_ORIG_CASE_MACRO_INS_NAME)
  (Description "The object's original instance name, which may be mixed-case or too long to match the Object name.")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oIODriver))
  (Version "15.3")
  (Tiering (Tier tTooHigh))
)
; For IO_NAME, the Enum list of names will be replaced at runtime with the list of available driver definition names
( Attribute
  (Name IO_NAME)
  (Description "The object's 'cell name' or 'part name'.")
  (Value (DataType (dEnum nil)) (ValueType vEnumSpecial) (Status sDerivedData))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_ORDER)
  (Description "The object's order in the buffer sequence (clockwise around ring)..")
  (Value (DataType (dInteger)) (Status sDerivedData))
  (Objects (ValidObjects oIODriver oIOTile))
  (Version "15.3")
)
( Attribute
  (Name IO_DIE_EDGE)
  (Description "The side of the die (North, South, East, West) the object is aligned with.")
  (Value (DataType (dEnum N S E W NE NW SE SW U)) (ValueType vEnum) (Status sDerivedData))
  (Objects (ValidObjects oIODriver oIOTile))
  (Version "15.3")
)
( Attribute
  (Name IO_OFFSET)
  (Description "The object's distance from the edge it is nearest.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sDerivedData))
  (Objects (ValidObjects oIODriver oIOTile))
  (Version "15.3")
)
( Attribute
  (Name IO_NET_NAME)
  (Description "The names of the nets attached to the object's pins [blank or (pinName) is a 'dummy net'].")
  (Value (DataType (dString)) (Status sDerivedData))
  (Objects (ValidObjects oIODriver))
  (Version "15.3")
)
( Attribute
  (Name IO_ORIENTATION)
  (Description "The mirroring/rotation of the object.")
  (Value (DataType (dEnum N FN E FE S FS W FW ODD FODD)) (ValueType vEnumSpecial) (Status sDerivedData))
  (Objects (ValidObjects oIODriver oIOTile))
  (Version "15.3")
)
( Attribute
  (Name IO_X)
  (Description "The object's origin's x-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sDerivedData))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_Y)
  (Description "The object's origin's y-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sDerivedData))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_WIDTH)
  (Description "The object's definition's width (X-direction).")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sReadOnly))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_LENGTH)
  (Description "The object's definition's length (Y-direction).")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sReadOnly))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_MIN_X)
  (Description "The object's extents' minimum x-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sReadOnly))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_MIN_Y)
  (Description "The object's extents' minimum y-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sReadOnly))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_MAX_X)
  (Description "The object's extents' maximum x-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sReadOnly))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
( Attribute
  (Name IO_MAX_Y)
  (Description "The object's extents' maximum y-coordinate.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sActual sReadOnly))
  (Objects (ValidObjects oIODriver oIOTile oIODie))
  (Version "15.3")
)
;=====================================================================================
; DRC ATTRIBUTES
; =========================================
( Attribute
  (Name DRC_CONSTRAINT_SET)
  (Description "The constraint set containing the violated rule.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oDRC))
  (Version "15.5")
)
( Attribute
  (Name DRC_SUBCLASS)
  (Description "The subclass information from the DRC.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oDRC))
  (Version "15.5")
)
( Attribute
  (Name DRC_VALUES_REQUIRED)
  (Description "The required values information from the DRC.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oDRC))
  (Version "15.5")
)
( Attribute
  (Name DRC_VALUES_ACTUAL)
  (Description "The actual values information from the DRC.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oDRC))
  (Version "15.5")
)
( Attribute
  (Name DRC_OBJECT1)
  (Description "The object1 information from the DRC.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oDRC))
  (Version "15.5")
)
( Attribute
  (Name DRC_OBJECT2)
  (Description "The object2 information from the DRC.")
  (Value (DataType (dString)) (Status sDerivedData sReadOnly))
  (Objects (ValidObjects oDRC))
  (Version "15.5")
)
;=====================================================================================
; Comments can apply to any objects but for now only enable them for a few.
; =========================================
( Attribute
  (Name COMMENT)
  (Description "The comment attached to the DRC.")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oXnet oNet oPinPair oDRC))
  (Version "15.7")
)

;=====================================================================================
; P&S ATTRIBUTES
; =================

( Attribute
  (Name ALLOW_ON_ETCH_SUBCLASS)
  (Description "Allow this object's etch on this layer")
  (Value (DataType (dListEnum TRUE FALSE)) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name ALLOW_ON_ETCH_SUBCLASS_VMODE)
  (Description "Allow this object's etch on this layer verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TS_ALLOWED)
  (Description "Allow this object's T-points on this layer")
  (Value (DataType (dListEnum NOT_ALLOWED ANYWHERE PINS_ONLY PINS_VIAS_ONLY)) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TS_ALLOWED_VMODE)
  (Description "Allow this object's T-points on this layer verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name MIN_BVIA_STAGGER)
  (Description "Minimum blind/buried via stagger")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (PropertyToRestrict (fMaxConstraintOrZero MAX_BVIA_STAGGER))
  (Version "16.0")
)
( Attribute
  (Name MIN_BVIA_STAGGER_VMODE)
  (Description "Minimum blind/buried via stagger verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name MAX_BVIA_STAGGER)
  (Description "Minimum blind/buried via stagger")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (PropertyToRestrict (fMinConstraintOrZero MIN_BVIA_STAGGER))
  (Version "16.0")
)
( Attribute
  (Name MAX_BVIA_STAGGER_VMODE)
  (Description "Maximum blind/buried via stagger verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name PAD_PAD_DIRECT_CONNECT)
  (Description "Pad to pad direct connect allowed")
  (Value (DataType (dListEnum ALL_ALLOWED VIAS_PINS_ONLY VIAS_VIAS_ONLY MICROVIAS_MICROVIAS_ONLY MICROVIAS_MICROVIAS_COINCIDENT_ONLY NOT_ALLOWED)) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oPCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name PAD_PAD_DIRECT_CONNECT_VMODE)
  (Description "Pad to pad direct connect allowed verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_THRUPIN_SPACING)
  (Description "Minimum thru pin to thru pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum thru pin to thru pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_SMDPIN_SPACING)
  (Description "Minimum thru pin to SMD pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum thru pin to SMD pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_THRUPIN_SPACING)
  (Description "Minimum thru pin to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum thru pin to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_THRUVIA_SPACING)
  (Description "Minimum thru pin to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum thru pin to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTVIA_TO_THRUPIN_SPACING)
  (Description "Minimum thru pin to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TESTVIA_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum thru pin to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_THRUPIN_SPACING)
  (Description "Minimum thru pin to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum thru pin to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_BONDPAD_SPACING)
  (Description "Minimum thru pin to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_BONDPAD_SPACING_VMODE)
  (Description "Minimum thru pin to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_THRUPIN_SPACING)
  (Description "Minimum thru pin to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum thru pin to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_SHAPE_SPACING)
  (Description "Minimum thru pin to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name THRUPIN_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum thru pin to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_SMDPIN_SPACING)
  (Description "Minimum SMD pin to SMD pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum SMD pin to SMD pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_TESTPIN_SPACING)
  (Description "Minimum SMD pin to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum SMD pin to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_THRUVIA_SPACING)
  (Description "Minimum SMD pin to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum SMD pin to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_TESTVIA_SPACING)
  (Description "Minimum SMD pin to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum SMD pin to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_SMDPIN_SPACING)
  (Description "Minimum SMD pin to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum SMD pin to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_BONDPAD_SPACING)
  (Description "Minimum SMD pin to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SMDPIN_TO_BONDPAD_SPACING_VMODE)
  (Description "Minimum SMD pin to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_SMDPIN_SPACING)
  (Description "Minimum SMD pin to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum SMD pin to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_SMDPIN_SPACING)
  (Description "Minimum SMD pin to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum SMD pin to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_TESTPIN_SPACING)
  (Description "Minimum test pin to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum test pin to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_THRUVIA_SPACING)
  (Description "Minimum test pin to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum test pin to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_TESTVIA_SPACING)
  (Description "Minimum test pin to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TESTPIN_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum test pin to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_TESTPIN_SPACING)
  (Description "Minimum test pin to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum test pin to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_TESTPIN_SPACING)
  (Description "Minimum test pin to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum test pin to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_TESTPIN_SPACING)
  (Description "Minimum test pin to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum test pin to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_TESTPIN_SPACING)
  (Description "Minimum test pin to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum test pin to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name THRUVIA_TO_THRUVIA_SPACING)
  (Description "Minimum thru via to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name THRUVIA_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum thru via to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTVIA_TO_THRUVIA_SPACING)
  (Description "Minimum thru via to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TESTVIA_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum thru via to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_THRUVIA_SPACING)
  (Description "Minimum thru via to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum thru via to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_THRUVIA_SPACING)
  (Description "Minimum thru via to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum thru via to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_THRUVIA_SPACING)
  (Description "Minimum thru via to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum thru via to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_THRUVIA_SPACING)
  (Description "Minimum thru via to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum thru via to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTVIA_TO_TESTVIA_SPACING)
  (Description "Minimum test via to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name TESTVIA_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum test via to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_TESTVIA_SPACING)
  (Description "Minimum test via to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum test via to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_TESTVIA_SPACING)
  (Description "Minimum test via to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum test via to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_TESTVIA_SPACING)
  (Description "Minimum test via to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum test via to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_TESTVIA_SPACING)
  (Description "Minimum test via to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum test via to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_BBV_SPACING)
  (Description "Minimum blind/buried via to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_BBV_SPACING_VMODE)
  (Description "Minimum blind/buried via to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_BBV_SPACING)
  (Description "Minimum blind/buried via to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_BBV_SPACING_VMODE)
  (Description "Minimum blind/buried via to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_LINE_SPACING)
  (Description "Minimum blind/buried via to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_LINE_SPACING_VMODE)
  (Description "Minimum blind/buried via to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_SHAPE_SPACING)
  (Description "Minimum blind/buried via to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BBV_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum blind/buried via to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_BONDPAD_SPACING)
  (Description "Minimum bond finger to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_BONDPAD_SPACING_VMODE)
  (Description "Minimum bond finger to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_LINE_SPACING)
  (Description "Minimum bond finger to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_LINE_SPACING_VMODE)
  (Description "Minimum bond finger to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_SHAPE_SPACING)
  (Description "Minimum bond finger to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum bond finger to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_LINE_SPACING)
  (Description "Minimum line to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_LINE_SPACING_VMODE)
  (Description "Minimum line to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_SHAPE_SPACING)
  (Description "Minimum line to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name LINE_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum line to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_SHAPE_SPACING)
  (Description "Minimum shape to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name SHAPE_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum shape to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name HOLE_TO_PIN_SPACING)
  (Description "Minimum hole to pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_PIN_SPACING_VMODE)
  (Description "Minimum hole to pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_VIA_SPACING)
  (Description "Minimum hole to via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_VIA_SPACING_VMODE)
  (Description "Minimum hole to via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_LINE_SPACING)
  (Description "Minimum hole to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_LINE_SPACING_VMODE)
  (Description "Minimum hole to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_SHAPE_SPACING)
  (Description "Minimum hole to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum hole to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_HOLE_SPACING)
  (Description "Minimum hole to hole spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name HOLE_TO_HOLE_SPACING_VMODE)
  (Description "Minimum hole to hole spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_MVIA_SPACING)
  (Description "Minimum microvia to microvia spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_MVIA_SPACING_VMODE)
  (Description "Minimum microvia to microvia spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_THRUPIN_SPACING)
  (Description "Minimum microvia to thru pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum microvia to thru pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_SMDPIN_SPACING)
  (Description "Minimum microvia to SMD pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum microvia to SMD pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_THRUVIA_SPACING)
  (Description "Minimum microvia to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum microvia to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_BBV_SPACING)
  (Description "Minimum microvia to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_BBV_SPACING_VMODE)
  (Description "Minimum microvia to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_LINE_SPACING)
  (Description "Minimum microvia to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_LINE_SPACING_VMODE)
  (Description "Minimum microvia to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_SHAPE_SPACING)
  (Description "Minimum microvia to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum microvia to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_TESTPIN_SPACING)
  (Description "Minimum microvia to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum microvia to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_TESTVIA_SPACING)
  (Description "Minimum microvia to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name MVIA_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum microvia to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name BONDPAD_TO_MVIA_SPACING)
  (Description "Minimum bond finger to microvia spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name BONDPAD_TO_MVIA_SPACING_VMODE)
  (Description "Minimum bond finger to microvia spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SAME_NET)
  (Description "Same net DRC allowed")
  (Value (DataType (dListEnum TRUE FALSE)) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
; <-- Obsolete, replaced by same-net spacing domain
( Attribute
  (Name MIN_BVIA_GAP)
  (Description "Minimum blind/buried via gap")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.0")
)
( Attribute
  (Name MIN_BVIA_GAP_VMODE)
  (Description "Minimum blind/buried via gap verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SN_THRUPIN_TO_THRUPIN_SPACING)
  (Description "Minimum same net thru pin to thru pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum same net thru pin to thru pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_SMDPIN_SPACING)
  (Description "Minimum same net thru pin to SMD pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum same net thru pin to SMD pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_THRUPIN_SPACING)
  (Description "Minimum same net thru pin to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum same net thru pin to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_THRUVIA_SPACING)
  (Description "Minimum same net thru pin to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net thru pin to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTVIA_TO_THRUPIN_SPACING)
  (Description "Minimum same net thru pin to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTVIA_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum same net thru pin to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_THRUPIN_SPACING)
  (Description "Minimum same net thru pin to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum same net thru pin to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_BONDPAD_SPACING)
  (Description "Minimum same net thru pin to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_BONDPAD_SPACING_VMODE)
  (Description "Minimum same net thru pin to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_THRUPIN_SPACING)
  (Description "Minimum same net thru pin to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum same net thru pin to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_SHAPE_SPACING)
  (Description "Minimum same net thru pin to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUPIN_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum same net thru pin to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_SMDPIN_SPACING)
  (Description "Minimum same net SMD pin to SMD pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum same net SMD pin to SMD pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_TESTPIN_SPACING)
  (Description "Minimum same net SMD pin to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum same net SMD pin to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_THRUVIA_SPACING)
  (Description "Minimum same net SMD pin to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net SMD pin to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_TESTVIA_SPACING)
  (Description "Minimum same net SMD pin to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net SMD pin to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_SMDPIN_SPACING)
  (Description "Minimum same net SMD pin to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum same net SMD pin to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_BONDPAD_SPACING)
  (Description "Minimum same net SMD pin to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SMDPIN_TO_BONDPAD_SPACING_VMODE)
  (Description "Minimum same net SMD pin to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_SMDPIN_SPACING)
  (Description "Minimum same net SMD pin to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum same net SMD pin to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_SMDPIN_SPACING)
  (Description "Minimum same net SMD pin to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum same net SMD pin to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_TESTPIN_SPACING)
  (Description "Minimum same net test pin to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum same net test pin to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_THRUVIA_SPACING)
  (Description "Minimum same net test pin to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net test pin to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_TESTVIA_SPACING)
  (Description "Minimum same net test pin to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTPIN_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net test pin to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_TESTPIN_SPACING)
  (Description "Minimum same net test pin to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum same net test pin to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_TESTPIN_SPACING)
  (Description "Minimum same net test pin to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum same net test pin to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_TESTPIN_SPACING)
  (Description "Minimum same net test pin to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum same net test pin to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_TESTPIN_SPACING)
  (Description "Minimum same net test pin to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum same net test pin to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUVIA_TO_THRUVIA_SPACING)
  (Description "Minimum same net thru via to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_THRUVIA_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net thru via to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTVIA_TO_THRUVIA_SPACING)
  (Description "Minimum same net thru via to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTVIA_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net thru via to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_THRUVIA_SPACING)
  (Description "Minimum same net thru via to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net thru via to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_THRUVIA_SPACING)
  (Description "Minimum same net thru via to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net thru via to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_THRUVIA_SPACING)
  (Description "Minimum same net thru via to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net thru via to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_THRUVIA_SPACING)
  (Description "Minimum same net thru via to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net thru via to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTVIA_TO_TESTVIA_SPACING)
  (Description "Minimum same net test via to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_TESTVIA_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net test via to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_TESTVIA_SPACING)
  (Description "Minimum same net test via to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net test via to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_TESTVIA_SPACING)
  (Description "Minimum same net test via to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net test via to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_TESTVIA_SPACING)
  (Description "Minimum same net test via to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net test via to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_TESTVIA_SPACING)
  (Description "Minimum same net test via to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net test via to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_BBV_SPACING)
  (Description "Minimum same net blind/buried via to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_BBV_SPACING_VMODE)
  (Description "Minimum same net blind/buried via to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_BBV_SPACING)
  (Description "Minimum same net blind/buried via to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_BBV_SPACING_VMODE)
  (Description "Minimum same net blind/buried via to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_LINE_SPACING)
  (Description "Minimum same net blind/buried via to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_LINE_SPACING_VMODE)
  (Description "Minimum same net blind/buried via to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_SHAPE_SPACING)
  (Description "Minimum same net blind/buried via to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BBV_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum same net blind/buried via to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_BONDPAD_SPACING)
  (Description "Minimum same net bond finger to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_BONDPAD_SPACING_VMODE)
  (Description "Minimum same net bond finger to bond finger spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_LINE_SPACING)
  (Description "Minimum same net bond finger to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_LINE_SPACING_VMODE)
  (Description "Minimum same net bond finger to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_SHAPE_SPACING)
  (Description "Minimum same net bond finger to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum same net bond finger to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_LINE_SPACING)
  (Description "Minimum same net line to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_LINE_SPACING_VMODE)
  (Description "Minimum same net line to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_SHAPE_SPACING)
  (Description "Minimum same net line to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_LINE_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum same net line to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_SHAPE_SPACING)
  (Description "Minimum same net shape to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oRegionClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_SHAPE_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum same net shape to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_PIN_SPACING)
  (Description "Minimum same net hole to pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_PIN_SPACING_VMODE)
  (Description "Minimum same net hole to pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_VIA_SPACING)
  (Description "Minimum same net hole to via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_VIA_SPACING_VMODE)
  (Description "Minimum same net hole to via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_LINE_SPACING)
  (Description "Minimum same net hole to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_LINE_SPACING_VMODE)
  (Description "Minimum same net hole to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_SHAPE_SPACING)
  (Description "Minimum same net hole to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum same net hole to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_HOLE_SPACING)
  (Description "Minimum same net hole to hole spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_HOLE_TO_HOLE_SPACING_VMODE)
  (Description "Minimum same net hole to hole spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_MVIA_SPACING)
  (Description "Minimum same net microvia to microvia spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_MVIA_SPACING_VMODE)
  (Description "Minimum same net microvia to microvia spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_THRUPIN_SPACING)
  (Description "Minimum same net microvia to thru pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_THRUPIN_SPACING_VMODE)
  (Description "Minimum same net microvia to thru pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_SMDPIN_SPACING)
  (Description "Minimum same net microvia to SMD pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_SMDPIN_SPACING_VMODE)
  (Description "Minimum same net microvia to SMD pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_THRUVIA_SPACING)
  (Description "Minimum same net microvia to thru via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_THRUVIA_SPACING_VMODE)
  (Description "Minimum same net microvia to thru via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_BBV_SPACING)
  (Description "Minimum same net microvia to blind/buried via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_BBV_SPACING_VMODE)
  (Description "Minimum same net microvia to blind/buried via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_LINE_SPACING)
  (Description "Minimum same net microvia to line spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_LINE_SPACING_VMODE)
  (Description "Minimum same net microvia to line spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_SHAPE_SPACING)
  (Description "Minimum same net microvia to shape spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_SHAPE_SPACING_VMODE)
  (Description "Minimum same net microvia to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_TESTPIN_SPACING)
  (Description "Minimum same net microvia to test pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_TESTPIN_SPACING_VMODE)
  (Description "Minimum same net microvia to test pin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_TESTVIA_SPACING)
  (Description "Minimum same net microvia to test via spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_MVIA_TO_TESTVIA_SPACING_VMODE)
  (Description "Minimum same net microvia to test via spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_MVIA_SPACING)
  (Description "Minimum same net bond finger to microvia spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSNSCSet oDesign oNetClass oNetGroup oBus oDiffPair oXnet oNet oPinPair))
  (Version "16.2")
)
( Attribute
  (Name SN_BONDPAD_TO_MVIA_SPACING_VMODE)
  (Description "Minimum same net bond finger to microvia spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name BONDPAD_TO_BONDPAD_DIFFP_SPC)
  (Description "Minimum same profile bond wire to bond wire spacing for differential pairs")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vDiffPairLayer) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oRegion oNetClassClass oRegionClass oRegionClassClass oSCSet oDesign oNetClass oNetGroup oDiffPair))
  (Domains dSpacing)
  (Version "16.2")
)
( Attribute
  (Name BONDPAD_TO_BONDPAD_DIFFP_SPC_VMODE)
  (Description "Minimum same profile bond wire to bond wire spacing for differential pairs verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)

;=====================================================================================
; Design level Bond Finger/Pad and Bond Wire CONSTRAINTS
; =======================================================
( Attribute
  (Name BONDWIRE_BONDWIRE_SPC)
  (Description "Minimum bond wire to bond wire spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile oClassClass)(NoInherit (oSystem oDesign)))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_BONDWIRE_SPC_VMODE)
  (Description "Minimum same profile bond wire to bond wire spacing verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_DIFF_PROFILE_SPC)
  (Description "Minimum different profile bond wire to bond wire spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly sObsolete))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.0")
)
( Attribute
  (Name BOND_WIRE_CROSSING_LENGTH)
  (Description "Maximum different profile bond wire to bond wire crossing length captured as a percentage")
  (Value (DataType (dListLong)) (Units uPercentage %) (ValueType vPercentage) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile oClassClass)(NoInherit (oSystem oDesign)))
  (Aliases BONDWIRE_CROSSING_LENGTH)
  (Version "16.0")
)
( Attribute
  (Name BOND_WIRE_CROSSING_LENGTH_VMODE)
  (Description "Maximum different profile bond wire to bond wire crossing length verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
)
( Attribute
  (Name BONDWIRE_DIFF_PROFILE_SPC_VMODE)
  (Description "Minimum different profile bond wire to bond wire spacing verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly sObsolete))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_BONDWIRE_CONNECT_SPC)
  (Description "Minimum bond wire end to bond wire end spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile oClassClass)(NoInherit (oSystem oDesign)))
  (Aliases BONDWIRE_BONDWIRE_CONNECTION_SP)
   (Version "16.0")
)
( Attribute
  (Name BONDWIRE_BONDWIRE_CONNECT_SPC_VMODE)
  (Description "Minimum bond wire end to bond wire end spacing verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases BONDWIRE_BONDWIRE_CONNECTION_SP_VMODE)
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_PIN_SPC)
  (Description "Minimum bond wire to pin spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile)(NoInherit (oSystem oDesign)))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_PIN_SPC_VMODE)
  (Description "Minimum bond wire to pin spacing verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_BONDPAD_SPC)
  (Description "Minimum bond wire to bond finger spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile)(NoInherit (oSystem oDesign)))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_BONDPAD_SPC_VMODE)
  (Description "Minimum bond wire to bond finger spacing verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name MIN_BOND_LENGTH)
  (Description "Minimum bond wire length")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile)(NoInherit (oSystem oDesign)))
  (Version "16.0")
)
( Attribute
  (Name MIN_BOND_LENGTH_VMODE)
  (Description "Minimum bond wire length verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name MAX_BOND_LENGTH)
  (Description "Maximum bond wire length")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile)(NoInherit (oSystem oDesign)))
  (Version "16.0")
)
( Attribute
  (Name MAX_BOND_LENGTH_VMODE)
  (Description "Maximum bond wire length verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign ))
  (Version "16.0")
)
( Attribute
  (Name MAX_LINE_EXIT_ANGLE)
  (Description "Maximum bond wire to die edge angle")
  (Value (DataType (dListDouble)) (Range (Min 0.0) (Max 180.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile)(NoInherit (oSystem oDesign)))
  (Version "16.0")
  (Tiering (Tier tXL))
)
( Attribute
  (Name MAX_LINE_EXIT_ANGLE_VMODE)
  (Description "Maximum bond wire to die edge angle verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_DIAMETER)
  (Description "Minimum bond wire diameter")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile)(NoInherit (oSystem oDesign)))
  (Version "16.0")
)
( Attribute
  (Name BONDWIRE_DIAMETER_VMODE)
  (Description "Minimum bond wire diameter verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_COMP_EDGE)
  (Description "Minimum bond finger to component edge spacing")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign oACSet oWireProfile)(NoInherit (oSystem oDesign)))
  (Version "16.0")
)
( Attribute
  (Name BONDPAD_COMP_EDGE_VMODE)
  (Description "Minimum bond finger to component edge spacing verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)

;=====================================================================================
; DESIGN CONSTRAINTS
; ==================

( Attribute
  (Name PACKAGE_PACKAGE_VMODE)
  (Description "Package to package spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name PACKAGE_KEEPIN_VMODE)
  (Description "Package to keepin spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name PACKAGE_KEEPOUT_VMODE)
  (Description "Package to keepout spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name ROOM_TYPE_VMODE)
  (Description "Package to room spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name PACKAGE_TO_CAVITY_SPACING)
  (Description "Package to Cavity spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.5")
  (Tiering (Tier tXL) (Options tMiniaturization))
)
( Attribute
  (Name PACKAGE_TO_CAVITY_SPACING_VMODE)
  (Description "Package to Cavity verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
)
( Attribute
  (Name PACKAGE_TO_LAYER_SPACING_VMODE)
  (Description "Package Height to Layer verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
)
( Attribute
  (Name SHAPE_ISLAND_OVERSIZE)
  (Description "Negative plane islands oversize")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dPhysical)
  (Version "16.0")
)
( Attribute
  (Name SHAPE_ISLAND_OVERSIZE_VMODE)
  (Description "Negative plane islands oversize verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_ALIGNMENT)
  (Description "Soldermask alignment tolerance")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_ALIGNMENT_VMODE)
  (Description "Soldermask alignment tolerance verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_SPACING)
  (Description "Soldermask to soldermask spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_SPACING_VMODE)
  (Description "Soldermask to soldermask spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_CLINE_SPACING)
  (Description "Soldermask to pad or cline spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_CLINE_SPACING_VMODE)
  (Description "Soldermask to pad or cline spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_SHAPE_SPACING)
  (Description "Soldermask to shape spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.0")
)
( Attribute
  (Name SOLDERMASK_SHAPE_SPACING_VMODE)
  (Description "Soldermask to shape spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TPPAD_CMP_SPACING)
  (Description "Testpoint pad to component spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.0")
)
( Attribute
  (Name TPPAD_CMP_SPACING_VMODE)
  (Description "Testpoint pad to component spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TPLOC_CMP_SPACING)
  (Description "Testpoint location to component spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.0")
)
( Attribute
  (Name TPLOC_CMP_SPACING_VMODE)
  (Description "Testpoint location to component spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name TESTPOINT_ALLOW_UNDER_VMODE)
  (Description "Testpoint allowed under component verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.0")
)
( Attribute
  (Name MECH_PIN_TO_MECH_PIN_SPACING)
  (Description "Mechanical pin to mechanical pin spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Aliases MECH_HOLE_TO_MECH_HOLE_SPACING)
  (Version "16.2")
)
( Attribute
  (Name MECH_PIN_TO_MECH_PIN_SPACING_VMODE)
  (Description "Mechanical pin to mechanical pin verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases MECH_HOLE_TO_MECH_HOLE_SPACING_VMODE)
  (Version "16.2")
)
( Attribute
  (Name MECH_PIN_TO_CONDUCTOR_SPACING)
  (Description "Mechanical pin to conductor spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Aliases MECH_HOLE_TO_CONDUCTOR_SPACING)
  (Version "16.2")
)
( Attribute
  (Name MECH_PIN_TO_CONDUCTOR_SPACING_VMODE)
  (Description "Mechanical pin to conductor spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases MECH_HOLE_TO_CONDUCTOR_SPACING_VMODE)
  (Version "16.2")
)
( Attribute
  (Name VIA_AT_SMD_VMODE)
  (Description "Allow vias in SMD pins verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name VIA_AT_SMD_FIT_VMODE)
  (Description "Vias in SMD pins must fit entirely inside verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name VIA_AT_SMD_THRU_VMODE)
  (Description "Allow thru vias in SMD pins verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name ETCH_TURN_UNDER_PAD_VMODE)
  (Description "Allow etch turns in SMD pins verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.2")
)
( Attribute
  (Name PASTEMASK_SPACING)
  (Description "Pastemask to pastemask spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.3")
)
( Attribute
  (Name PASTEMASK_SPACING_VMODE)
  (Description "Pad pastemask to pad pastemask spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
( Attribute
  (Name NEGATIVE_PLANE_SLIVER_SPACING)
  (Description "Negative plane sliver spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.3")
)
( Attribute
  (Name NEGATIVE_PLANE_SLIVER_SPACING_VMODE)
  (Description "Negative plane sliver verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
( Attribute
  (Name VIA_LIST_VMODE)
  (Description "Via List verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
( Attribute
  (Name PIN_TO_ROUTE_KEEPOUT_VMODE)
  (Description "Pin to route keepout verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
( Attribute
  (Name BBVIA_SEPARATION)
  (Description "BB Via layer separation")
  (Value (DataType (dLong)) (Range (Min 0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
; Not in use in 16.4. See CCMPR00803396, CCMPR00836312, CCMPR00873280
; Keep in dictionary to prevent auto-creation in flow.
( Attribute
  (Name SAME_NET_MIN_METAL_SPACING)
  (Description "Minimum same net metal to metal spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sProperty sControl sCMEditOnly sHidden sNoMerge))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.4")
)
( Attribute
  (Name SAME_NET_MIN_METAL_SPACING_VMODE)
  (Description "Minimum same net metal to metal spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly sHidden sNoMerge))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.4")
)
( Attribute
  (Name MIN_METAL_SPACING)
  (Description "Minimum metal to metal spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.5")
)
( Attribute
  (Name MIN_METAL_SPACING_VMODE)
  (Description "Minimum metal to metal spacing verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
)
( Attribute
  (Name DUP_DRILL_HOLE_VMODE)
  (Description "Duplicate Drill Hole verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.5")
)
( Attribute
  (Name MAXIMUM_CAVITY_SIZE)
  (Description "Maximum cavity area")
  (Value (DataType (dDouble)) (Units uDesign mil dimension 2) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.6")
  (Tiering (Tier tXL) (Options tMiniaturization))
)
( Attribute
  (Name MAXIMUM_CAVITY_SIZE_VMODE)
  (Description "Maximum cavity area verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
( Attribute
  (Name MAXIMUM_CAVITY_COMPONENT_COUNT)
  (Description "Maximum cavity component count")
  (Value (DataType (dLong)) (Range (Min 0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dSpacing)
  (Version "16.6")
  (Tiering (Tier tXL) (Options tMiniaturization))
)
( Attribute
  (Name MAXIMUM_CAVITY_COMPONENT_COUNT_VMODE)
  (Description "Maximum cavity component count verification mode")
  (Value (DataType (dEnum ON BATCH OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)

;=====================================================================================
; LAYER DATA
; ==========
( Attribute
  (Name CDS_LAYER_TYPE)
  (Description "The type of the layer (surface, conductor, dielectric, etc.).")
  (Value (DataType (dEnum SURFACE CONDUCTOR DIELECTRIC PLANE MULTIWIRE MICROWIRE CROSSOVER DIE DIESTACK BONDING_WIRE OPTICAL_WAVE THERMAL_GLUE)) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_MATERIAL)
  (Description "The material of the layer (air, copper, FR-4, etc.).")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_THICKNESS)
  (Description "The layer thickness, in design units.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_ELECTRICAL_CONDUCTIVITY)
  (Description "The layer's electrical conductivity.")
  (Value (DataType (dDouble)) (Format "%6g")(Units uElectricalConductivity mho/cm) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_THERMAL_CONDUCTIVITY)
  (Description "The layer's thermal conductivity.")
  (Value (DataType (dDouble)) (Units uThermalConductivity W/cm-degC) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_DIELECTRIC_CONSTANT)
  (Description "The layer's dielectric constant.")
  (Value (DataType (dDouble)) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_LOSS_TANGENT)
  (Description "The layer's loss tangent.")
  (Value (DataType (dDouble)) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_NEGATIVE_ARTWORK)
  (Description "Is the layer's artwork negative?")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_IS_SHIELD)
  (Description "Is the layer a shield layer?")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_IS_NAMED)
  (Description "Is the layer a conductor layer?")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty sNoEditor))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_IS_TOP_SUBSTRATE)
  (Description "Is the layer the top substrate for APD/SiP?")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty sNoEditor))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_IS_BOTTOM_SUBSTRATE)
  (Description "Is the layer the bottom substrate for APD/SiP?")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty sNoEditor))
  (Objects (ValidObjects oLayer))
  (Version "16.0")
)
( Attribute
  (Name CDS_LAYER_FREQ_DEP_FILE)
  (Description "The frequency-dependent material properties file of the layer.")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.2")
)
( Attribute
  (Name CDS_LAYER_ETCH_FACTOR)
  (Description "The etch factor of the layer, in degrees of arc.")
  (Value (DataType (dDouble)) (Range (Min 45.0) (Max 315.0)) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.2")
)
( Attribute
  (Name CDS_LAYER_EMBEDDED_STATUS)
  (Description "The embedded status of the layer (NON_EMBEDDED, BODY_UP, BODY_DOWN.")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.5")
)
( Attribute
  (Name CDS_LAYER_EMBEDDED_ATTCH)
  (Description "The embedded attach method of the layer (DIRCTECT_ATTACH, INDIRECT_ATTACH.")
  (Value (DataType (dString)) (Status sProperty))
  (Objects (ValidObjects oLayer))
  (Version "16.5")
)



;=====================================================================================
; RATSNEST BUNDLES
; All attributes are readonly for now. Allegro DB update is not supported by CM.
; ================
( Attribute
  (Name PLAN_LAYER_MATCH)
  (Description "Consider layer matching during planning.")
  (Value (DataType (dEnum TRUE FALSE)) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.1")
  (Tiering (Options tRatbundle tGRE))
)
( Attribute
  (Name PLAN_MAX_TRANSITION_COUNT)
  (Description "Maximum number of transitions allowed during planning.")
  (Value (DataType (dEnumOrString NL)) (Units uInteger)(ValueType vEnumOrInteger) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_ELONGATION_PATTERN)
  (Description "Pattern type for elongation added in planning.")
  (Value (DataType (dEnum TROMBONE ACCORDION)) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_MIN_WRAP_GAP)
  (Description "Accordion pattern: minimum gap in elongation added in planning.")
  (Value (DataType (dString))(Units uDesignOrXWidth mil) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_MIN_AMPLITUDE)
  (Description "Accordion pattern: minimum amplitude of elongation added in planning.")
  (Value (DataType (dEnumOrString NL)) (Units uDesignOrXWidth mil) (ValueType vEnumOrString) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (PropertyToRestrict (fMaxConstraint PLAN_MAX_AMPLITUDE))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_MAX_AMPLITUDE)
  (Description "Accordion pattern: maximum amplitude of elongation added in planning.")
  (Value (DataType (dEnumOrString NL)) (Units uDesignOrXWidth mil) (ValueType vEnumOrString) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (PropertyToRestrict (fMinConstraint PLAN_MIN_AMPLITUDE))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_CORNER_TYPE)
  (Description "Accordion pattern: corner type for elongation added in planning.")
  (Value (DataType (dEnum 90 45 )) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_CORNER_LEN)
  (Description "Accordion pattern: corner length in elongation added in planning.")
  (Value (DataType (dString)) (Units uDesignOrXWidth mil)(Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_BUNDLE_SPACING)
  (Description "Spacing between ratsnest bundle members for planning.")
  (Value (DataType (dEnum Default MinDRC)) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.1")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name NO_XNET_CONNECTION)
  (Description "Prevent XNet connection.")
  (Value (DataType (dBoolean)) (Status sProperty sPackage))
  (Objects (ValidObjects oPart oGate))
  (Version "16.2")
)
( Attribute
  (Name PLAN_TR_MIN_WRAP_GAP)
  (Description "Trombone pattern: minimum gap in elongation added in planning.")
  (Value (DataType (dString))(Units uDesignOrXWidth mil) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.6")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_TR_MIN_AMPLITUDE)
  (Description "Trombone pattern: minimum amplitude of elongation added in planning.")
  (Value (DataType (dEnumOrString NL)) (Units uDesignOrXWidth mil) (ValueType vEnumOrString) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (PropertyToRestrict (fMaxConstraint PLAN_TR_MAX_LEVELS))
  (Version "16.6")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_TR_MAX_LEVELS)
  (Description "Trombone pattern: maximum levels of elongation added in planning.")
  (Value (DataType (dInteger)) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (PropertyToRestrict (fMinConstraint PLAN_TR_MIN_AMPLITUDE))
  (Version "16.6")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_TR_CORNER_TYPE)
  (Description "Trombone pattern: corner type for elongation added in planning.")
  (Value (DataType (dEnum 90 45 )) (ValueType vEnum) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.6")
  (Tiering (Options tRatbundle))
)
( Attribute
  (Name PLAN_TR_CORNER_LEN)
  (Description "Trombone pattern: corner length in elongation added in planning.")
  (Value (DataType (dString)) (Units uDesignOrXWidth mil) (Status sProperty))
  (Objects (ValidObjects oDesign oRatBundle))
  (Version "16.6")
  (Tiering (Options tRatbundle))
)

;=====================================================================================
; ASSEMBLY RULE CHECKS ATTRIBUTES
;================
;Die Rules
;================
;------------------------------------------------------------------------------
;1. Die Overhang Rule
;-----------------
( Attribute
  (Name ADRC_DIE_OVERHANG_XOVERLAP)
  (Description "Maximum Allowed X-overlap.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status  sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer))
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_OVERHANG_YOVERLAP)
  (Description "Maximum Allowed Y-overlap.")
  (Value (DataType (dDouble)) (Units uDesign mil)  (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer))
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_OVERHANG_XOVERLAP_VMODE)
  (Description "Die Overhang Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign ))
  (Aliases ADRC_DIE_OVERHANG_YOVERLAP_VMODE)

  (Version "16.3")
)

;---------------------
; 2. Die Pad to Lower Die Overhang
;---------------------
( Attribute
  (Name ADRC_DIE_PAD_LWR_DIE_MAX_LAP)
  (Description "Maximum Allowed Die Pad to Lower Die Overlap.")
  (Value (DataType (dDouble)) (Units uDesign mil)  (Range (Min 0.0)) (Status sNoUnitStr sMinConstraint   sCMEditOnly))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer))  
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_PAD_LWR_DIE_MAX_LAP_VMODE)
  (Description "Die Pad to Lower Die Overhang Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign ) )
  (Version "16.3")
)
;---------------------
; 3. Die Pad to Upper Die Spacing  
;---------------------
( Attribute
  (Name ADRC_DIE_PAD_TO_UPPER_DIE_SPC)
  (Description "Minimum Required Die Pad to Upper Die Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0))(Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer ) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_PAD_TO_UPPER_DIE_SPC_VMODE)
  (Description "Die Pad to Upper Die Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign ))
  (Version "16.3")
)
;---------------------
; 4. Die to Bond Finger Spacing 
;---------------------
( Attribute
  (Name ADRC_DIE_TO_BOND_FNGR_SPC)
  (Description "Minimum Required Die to Bond Finger Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil)(Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_TO_BOND_FNGR_SPC_VMODE)
  (Description "Die to Bond Finger Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign) )
  (Version "16.3")
)
;---------------------
; 5. Die to Connected Bond Finger Spacing 
;---------------------
( Attribute
  (Name ADRC_DIE_TO_CNCTD_BOND_FNGR_SPC)
  (Description "Minimum Required Die to Connected Bond Finger Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_TO_CNCTD_BOND_FNGR_SPC_VMODE)
  (Description "Die to Connected Bond Finger Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign) )
  (Version "16.3")
)
;---------------------
; 6. Die to Die Spacing, Connected Dies 
;---------------------
( Attribute
  (Name ADRC_DIE_TO_DIE_SPC_CNCTD_DIES)
  (Description "Minimum Required Die to Die Spacing, Connected Dies .")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0))(Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer oClassClass) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_TO_DIE_SPC_CNCTD_DIES_VMODE)
  (Description "Die to Die Spacing, Connected Dies Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign ) )
  (Version "16.3")
)
;---------------------
; 7. Die to Die Spacing, Unconnected Dies 
;---------------------
( Attribute
  (Name ADRC_DIE_TO_DIE_SPC_UNCNCTD)
  (Description "Minimum Required Die to Die Spacing, Unconnected Dies .")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oIODie oPartClass  oInterposer oSpacer oClassClass) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_TO_DIE_SPC_UNCNCTD_VMODE)
  (Description "Die to Die Spacing, Unconnected Dies Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign ) )
  (Version "16.3")
)
;---------------------
; 8. Die to Package Edge Spacing 
;---------------------
( Attribute
  (Name ADRC_DIE_TO_PACKAGE_EDGE_SPC)
  (Description "Minimum Required Die to Package Edge Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie oInterposer oSpacer) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_TO_PACKAGE_EDGE_SPC_VMODE)
  (Description "Die to Package Edge Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign ) )
  (Version "16.3")
)
;---------------------
; 52.	Die Pad Pitch
;---------------------
( Attribute
  (Name ADRC_DIE_PAD_PITCH_SPC )
  (Description "Minimum Required Die Pad Pitch.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oPartClass oIODie) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_PAD_PITCH_SPC_VMODE)
  (Description "Die Pad Pitch Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;================
;Die Stack Rules
;================
;---------------------
; 9. Die Stack to Die Stack Spacing 
;---------------------
( Attribute
  (Name ADRC_DIE_STACK_TO_DIE_STACK_SPC)
  (Description "Minimum Required Die Stack to Die Stack Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_STACK_TO_DIE_STACK_SPC_VMODE)
  (Description "Die Stack to Die Stack Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign) )
  (Version "16.3")
)
;---------------------
; 10. Die Stack Height
;---------------------
( Attribute
  (Name ADRC_TOTAL_STACKING_HEIGHT_TOP)
  (Description "Maximum Allowed Die Stack Height on Top Substrate .")
  (Value (DataType (dDouble)) (Units uDesign mil)(Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet ) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_TOTAL_STACKING_HEIGHT_BOT)
  (Description "Maximum Allowed Die Stack Height on Bottom Substrate .")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_TOTAL_STACKING_HEIGHT_TOP_VMODE)
  (Description "Total Die Stack Height Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases ADRC_TOTAL_STACKING_HEIGHT_BOT_VMODE)
  (Version "16.3")
)
;---------------------
; 11. Center to Center Delta  - extents based
;---------------------
( Attribute
  (Name ADRC_CNTR_TO_CNTR_DELTA_EXTS)
  (Description "Maximum Allowed Center to Center Delta ( extents based).")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet ) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_CNTR_TO_CNTR_DELTA_EXTS_VMODE)
  (Description "Center to Center Delta  - extents based- Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 12. Center to Center Delta  - pins based
;---------------------
( Attribute
  (Name ADRC_CNTR_TO_CNTR_DELTA_PINS)
  (Description "Maximum Allowed Center to Center Delta ( pins based).")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_CNTR_TO_CNTR_DELTA_PINS_VMODE)
  (Description "Center to Center Delta  - pins based- Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;==================
; Wire Rules
; =================
; Online Wire Rules Constraints see "Bond Finger/Pad and Bond Wire CONSTRAINTS" section
;---------------------
; 14.Wire Length Over Lower Die
;---------------------
( Attribute
  (Name ADRC_WIRE_LEN_OVER_DIE_MAX)
  (Description "Maximum Bond Wire Length Over Lower Die Stack Member.")
  (Value (DataType (dString)) (Units uLengthPercent um) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_LEN_OVER_DIE_MAX_VMODE)
  (Description "Maximum Bond Wire Length Over Lower Die Stack Member Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign ))
  (Version "16.3")
)
;---------------------
; 15.Wire Length Over Parent Die
;---------------------
( Attribute
  (Name ADRC_WIRE_LEN_OVER_PARENT_DIE)
  (Description "Maximum Bond Wire Length Over Parent Die.")
  (Value (DataType (dString)) (Units uLengthPercent um) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_LEN_OVER_PARENT_DIE_VMODE)
  (Description "Maximum Bond Wire Length Over Parent Die Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign ))
  (Version "16.3")
)
;---------------------
; 17.Maximum Wire Angle To Bond Finger
;---------------------
( Attribute
  (Name ADRC_WIRE_MAX_ANGL_TO_BOND_FNGR)
  (Description "Maximum Wire to Bond Finger Angle")
  (Value (DataType (dDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 360.0))(Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_MAX_ANGL_TO_BOND_FNGR_VMODE)
  (Description "Maximum Wire to Bond Finger Angle Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 22.Wire to Component Spacing
;---------------------
( Attribute
  (Name ADRC_WIRE_TO_COMPONENT_SPC)
  (Description "Minimum bond wire to component edge spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_TO_COMPONENT_SPC_VMODE)
  (Description "Minimum bond wire to component edge spacing verification mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WR_END_TO_S_MASK_SPC_SHAPE)
  (Description "Minimum Bond Wire Substrate End on Shape to Merged Soldermask Shape Gap")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WR_END_TO_S_MASK_SPC_SHAPE_VMODE)
  (Description "Minimum Bond Wire Substrate End on Shape to Merged Soldermask Gap Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))

  (Version "16.3")
)
( Attribute
  (Name ADRC_WR_END_TO_S_MASK_SPC_FNGR)
  (Description "Minimum Bond Wire Substrate End on Bondfinger to Merged Soldermask Shape Gap")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WR_END_TO_S_MASK_SPC_FNGR_VMODE)
  (Description "Minimum Bond Wire Substrate End on Bondfinger to Merged Soldermask Shape Gap Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))

  (Version "16.3")
)
( Attribute
  (Name ADRC_TACK_PT_ALONG_S_MASK_GAP)
  (Description "Minimum Bond Wire Substrate End on Any Metal To Merged Solder Mask Gap Along the Vector of Wire")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_ALONG_S_MASK_GAP_VMODE)
  (Description "Minimum Bond Wire Substrate End on Any Metal To Merged Solder Mask Gap Along the Vector of Wire Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))

  (Version "16.6")
)
;----------------------------------
; Tack Point on Metal Rules
;----------------------------------
( Attribute
  (Name ADRC_TACK_PT_TO_FINGER_EDGE_GAP)
  (Description "Minimum Bond Wire Tack Point to Bond Finger Edge Gap")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_TO_FINGER_EDGE_GAP_VMODE)
  (Description "Minimum Bond Wire Tack Point to Bond Finger Edge Gap Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))

  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_TO_DIEPIN_EDGE_GAP)
  (Description "Minimum Bond Wire Tack Point to Die Pin Edge Gap")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_TO_DIEPIN_EDGE_GAP_VMODE)
  (Description "Minimum Bond Wire Tack Point to Die Pin Edge Gap Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))

  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_TO_SHAPE_GAP)
  (Description "Minimum Bond Wire Tack Point to Connected Metal Edge Gap")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_TO_SHAPE_GAP_VMODE)
  (Description "Minimum Bond Wire Tack Point to Connected Metal Edge Gap Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))

  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_ALONG_METAL_GAP)
  (Description "Minimum Bond Wire Tack Point To Merged Connected Metal Gap Along the Vector of Wire")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_ALONG_METAL_GAP_VMODE)
  (Description "Minimum Bond Wire Tack Point To Merged Connected Metal Gap Along the Vector of Wire Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))

  (Version "16.6")
)
;---------------------
; Wire to Cavity Rules

( Attribute
  (Name ADRC_WIRE_TO_CAVITY_SPC)
  (Description "Minimum Bond Wire To Cavity Spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.6")
)
( Attribute
  (Name ADRC_WIRE_TO_CAVITY_SPC_VMODE)
  (Description "Minimum Bond Wire To Cavity Spacing Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_TO_CAVITY_SPC)
  (Description "Minimum Bond Wire Tack Point To Cavity Spacing")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign oACSet oWireProfile))
  (Version "16.6")
)
( Attribute
  (Name ADRC_TACK_PT_TO_CAVITY_SPC_VMODE)
  (Description "Minimum Bond Wire Tack Point To Cavity Spacing Verification Mode")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode sControl sCMEditOnly))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
;==================
; Optical Rules
; =================
;---------------------
; 24.Wire to Wire Optical Short, Die to Substrate 
;---------------------
( Attribute
  (Name ADRC_OPT_SHRT_DIE_TO_SBSTR_MIN)
  (Description "Minimum Value of the Length of the Longer Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0)) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet ) )
  (PropertyToRestrict (fMaxConstraint ADRC_OPT_SHRT_DIE_TO_SBSTR_MAX))
  (Version "16.3")
)
( Attribute
  (Name ADRC_OPT_SHRT_DIE_TO_SBSTR_MAX)
  (Description "Maximum Value of the Length of the Longer Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0))(Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet) )
  (PropertyToRestrict (fMinConstraint ADRC_OPT_SHRT_DIE_TO_SBSTR_MIN))
  (Version "16.3")
)
( Attribute
  (Name ADRC_OPT_SHRT_DIE_TO_SBSTR_MIN_VMODE)
  (Description "Die to Substrate Optical Short Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases ADRC_OPT_SHRT_DIE_TO_SBSTR_MAX_VMODE)
  (Version "16.3")
)
;---------------------
; 25.Wire to Wire Optical Short, Die to Die
;---------------------
( Attribute
  (Name ADRC_OPT_SHRT_DIE_TO_DIE_MIN)
  (Description "Minimum Value of the Length of the Longer Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0)) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet) )
  (PropertyToRestrict (fMaxConstraint ADRC_OPT_SHRT_DIE_TO_DIE_MAX))
  (Version "16.3")
)
( Attribute
  (Name ADRC_OPT_SHRT_DIE_TO_DIE_MAX)
  (Description "Maximum Value of the Length of the Longer Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0)) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet) )
  (PropertyToRestrict (fMinConstraint ADRC_OPT_SHRT_DIE_TO_DIE_MIN))
  (Version "16.3")
)
( Attribute
  (Name ADRC_OPT_SHRT_DIE_TO_DIE_MIN_VMODE)
  (Description "Die to Die Optical Short Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases ADRC_OPT_SHRT_DIE_TO_DIE_MAX_VMODE)
  (Version "16.3")
)
;---------------------
; 26.Wire to Die Pad Optical Short 
;---------------------
( Attribute
  (Name  ADRC_WIRE_TO_PIN_OPT_SHRT_MIN)
  (Description "Minimum Value of the Length of the Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0)) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet) )
  (PropertyToRestrict (fMaxConstraint ADRC_WIRE_TO_PIN_OPT_SHRT_MAX))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_TO_PIN_OPT_SHRT_MAX)
  (Description "Maximum Value of the Length of the Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0)) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet) )
  (PropertyToRestrict (fMinConstraint ADRC_WIRE_TO_PIN_OPT_SHRT_MIN))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_TO_PIN_OPT_SHRT_MIN_VMODE)
  (Description "Die to Die Pad Optical Short Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases ADRC_WIRE_TO_PIN_OPT_SHRT_MAX_VMODE)
  (Version "16.3")
)
;---------------------
; 27.	Wire to Bond Finger Optical Short
;---------------------
( Attribute
  (Name ADRC_WIRE_TO_FNGR_OPT_SHRT_MIN)
  (Description "Minimum Value of the Length of the Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0)) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet) )
  (PropertyToRestrict (fMaxConstraint ADRC_WIRE_TO_FNGR_OPT_SHRT_MAX))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_TO_FNGR_OPT_SHRT_MAX)
  (Description "Maximum Value of the Length of the Wire")
  (Value (DataType (dString)) (Units uLengthPercent um) (Range (Min 0.0)) (Status sProperty sCMEditOnly  )) 
  (Objects (ValidObjects oDesign  oACSet) )
  (PropertyToRestrict (fMinConstraint ADRC_WIRE_TO_FNGR_OPT_SHRT_MIN))
  (Version "16.3")
)
( Attribute
  (Name ADRC_WIRE_TO_FNGR_OPT_SHRT_MIN_VMODE)
  (Description "Die to Bond Finger Optical Short Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases ADRC_WIRE_TO_FNGR_OPT_SHRT_MAX_VMODE)
  (Version "16.3")
)
;======================
;Die Flag Rules
;======================
;----------------------
; 28.	Die Flag to Discrete Component Pad Spacing
;----------------------
( Attribute
  (Name ADRC_DIE_FL_TO_DSCR_CMP_PAD_SPC)
  (Description "Minimum Required Die Flag to Discrete Component Pad Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_FL_TO_DSCR_CMP_PAD_SPC_VMODE)
  (Description "Die Flag to Discrete Component Pad Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 29.	Die Flag to Die Flag Spacing
;----------------------
( Attribute
  (Name ADRC_DIE_FLAG_TO_DIE_FLAG_SPC)
  (Description "Minimum Required Die Flag to Die Flag Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_FLAG_TO_DIE_FLAG_SPC_VMODE)
  (Description "Die Flag to Die Flag Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 30.	Die Flag to Bond Finger Spacing
;----------------------
( Attribute
  (Name ADRC_DIE_FLAG_TO_BOND_FNGR_SPC)
  (Description "Minimum Required Die Flag to Bond Finger Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_FLAG_TO_BOND_FNGR_SPC_VMODE)
  (Description "Die Flag to Bond Finger Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 31.	Die Flag to Package Edge Spacing
;----------------------
( Attribute
  (Name ADRC_DIE_FLAG_TO_PACK_EDGE_SPC)
  (Description "Minimum Required Die Flag to Package Edge Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DIE_FLAG_TO_PACK_EDGE_SPC_VMODE)
  (Description "Die Flag to Package Edge Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;======================
;Shape Rules
;======================
;----------------------
; 32.	Minimum Shape Check
;----------------------
( Attribute
  (Name ADRC_MINIMUM_SHAPE_CHECK_SPC )
  (Description "Minimum Required Size.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_MINIMUM_SHAPE_CHECK_SPC_VMODE)
  (Description "Minimum Shape Check Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl ))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 33.	Minimum Void Check
;----------------------
( Attribute
  (Name ADRC_MINIMUM_VOID_CHECK_SPC )
  (Description "Minimum Required Size.")
 (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_MINIMUM_VOID_CHECK_SPC_VMODE)
  (Description "Minimum Void Check Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 34.	Acute Angle Shape Boundary
;----------------------
( Attribute
  (Name ADRC_ACUTE_ANGLE_SHAPE_BOUNDARY )
  (Description "Minimum Legal Angle.")
  (Value (DataType (dListDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 90.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)

( Attribute
  (Name ADRC_ACUTE_ANGLE_SHAPE_BOUNDARY_VMODE)
  (Description "Acute Angle  Shape Boundary Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dAssembly)  
  (Version "16.3")
)
;----------------------
; 35.	Conductor Shape Void Overlap
;----------------------
( Attribute
  (Name ADRC_COND_SHAPE_VOID_OVERLAP_VMODE)
  (Description "Conductor Shape Void Overlap Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dAssembly)
  (Version "16.3")
)
;======================
;Acute Angle Metal Rules
;======================
;----------------------
; 36.	Acute Angle Merged Metal Check
;----------------------
( Attribute
  (Name ADRC_ACUTE_ANGLE_METAL_CHECK )
  (Description "Minimum Legal Angle.")
  (Value (DataType (dListDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 90.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_ACUTE_ANGLE_METAL_CHECK_VMODE)
  (Description "Acute Angle  Merged Metal Check Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 37.	Acute Angle Routing
;----------------------
( Attribute
  (Name ADRC_ACUTE_ANGLE_ROUTING )
  (Description "Minimum Legal Angle.")
  (Value (DataType (dListDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 90.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)

( Attribute
  (Name ADRC_ACUTE_ANGLE_ROUTING_VMODE)
  (Description "Acute Angle  Routing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dAssembly)
  (Version "16.3")
)
;----------------------
; 38.	Trace Minimum Angle to Pad
;----------------------
( Attribute
  (Name ADRC_TRACE_MIN_ANG_TO_PAD )
  (Description "Minimum Legal Angle.")
  (Value (DataType (dListDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 90.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_TRC_MIN_ANG_TO_PAD_NO_FNGR)
  (Description "Check Bond Fingers.")
  (Value (DataType (dBoolean)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oDesign   oACSet) )
  (Version "16.3")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name ADRC_TRACE_MIN_ANG_TO_PAD_VMODE)
  (Description "Trace Minimum Angle To Pad Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 39.	Trace Minimum Angle to Shape
;----------------------
( Attribute
  (Name ADRC_TRACE_MIN_ANGLE_TO_SHAPE )
  (Description "Minimum Legal Angle.")
  (Value (DataType (dListDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 90.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_TRACE_MIN_ANGLE_TO_SHAPE_VMODE)
  (Description "Trace Minimum Angle To Shape Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 40.	Trace Minimum Angle to Trace
;----------------------
( Attribute
  (Name ADRC_TRACE_MIN_ANGLE_TO_TRACE )
  (Description "Minimum Legal Angle.")
  (Value (DataType (dListDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 90.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_TRACE_MIN_ANGLE_TO_TRACE_VMODE)
  (Description "Trace Minimum Angle To Trace Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;==================
; 	Solder Mask Rules
; =================
;---------------------
; 41.	Continues Solder Mask Coverage Check
;---------------------

( Attribute
  (Name ADRC_CONTINUES_S_MASK_COVERAGE_VMODE)
  (Description "Continues Solder Mask Coverage Check Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign ) )
  (Domains dAssembly)
  (Version "16.3")
)
;----------------------
; 42.	Solder Mask to Die Edge Spacing
;----------------------
( Attribute
  (Name ADRC_S_MASK_TO_DIE_EDGE_SPC  )
  (Description "Minimum Required Solder Mask To Die Edge Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_S_MASK_TO_DIE_IGNRE_UNDER)
  (Description "Check Solder Mask Under the Die.")
  (Value (DataType (dBoolean)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
  (Tiering (Tier tTooHigh))
)
( Attribute
  (Name ADRC_S_MASK_TO_DIE_EDGE_SPC_VMODE)
  (Description "Solder Mask to Die Edge Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 43.	Solder Mask to Package Edge Spacing
;----------------------
( Attribute
  (Name ADRC_S_MASK_TO_PACK_EDGE_SPC  )
  (Description "Minimum Required Solder Mask To Package Edge Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_S_MASK_TO_PACK_EDGE_SPC_VMODE)
  (Description "Solder Mask to Package Edge Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 44.	Solder Mask to Solder Mask Spacing
;----------------------
( Attribute
  (Name ADRC_S_MASK_TO_S_MASK_SPC  )
  (Description "Minimum Required Solder Mask To Solder Mask Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_S_MASK_TO_S_MASK_SPC_VMODE)
  (Description "Solder Mask to Solder Mask Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 	Soldermask Minimum Shape Check
;----------------------
( Attribute
  (Name ADRC_MIN_SM_SHAPE  )
  (Description "Minimum Required Solder Mask Shape Size.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_MIN_SM_SHAPE_VMODE)
  (Description "Minimum Required Solder Mask Shape Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;----------------------
; 43.	Solder Mask Minimum Void Check
;----------------------
( Attribute
  (Name ADRC_MIN_SM_VOID  )
  (Description "Minimum Required Solder Mask Void Size.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_MIN_SM_VOID_VMODE)
  (Description "Minimum Required Solder Mask Void Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;-------------------------------------
; Solder Mask to Unfilled Via Drill Spacing
;-------------------------------------
( Attribute
  (Name ADRC_SM_TO_UNFILLED_DRILL_SPC  )
  (Description "Minimum Required Solder Mask To Unfilled Via Drill Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)
( Attribute
  (Name ADRC_SM_TO_UNFILLED_DRILL_SPC_VMODE)
  (Description "Minimum Required Solder Mask To Unfilled Via Drill Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
( Attribute
  (Name ADRC_SM_TO_FILLED_DRILL_SPC )
  (Description "Minimum Required Solder Mask To Filled Via Drill Spacing.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)
( Attribute
  (Name ADRC_SM_TO_FILLED_DRILL_SPC_VMODE)
  (Description "Minimum Required Solder Mask To Filled Via Drill Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
;==================
; Package Substrate Rules
; =================
;---------------------
; 45.	Any Metal to Any Metal Spacing
;---------------------
( Attribute
  (Name ADRC_METAL_TO_METAL_SPC   )
 (Description "Minimum Required Any Metal to Any Metal Spacing The Same Net.")
 (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)


( Attribute
  (Name ADRC_MET_TO_MET_SPC_DIFF_NET   )
  (Description "Minimum Required Any Metal to Any Metal Spacing Different Net.")
  (Value (DataType (dListDouble)) (Units uDesign mil)  (Range (Min 0.0)) (ValueType vLayer) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)

( Attribute
  (Name ADRC_METAL_TO_METAL_ON_OFF   )
  (Description "Run / Do Not Run check for the specified layer")
  (Value (DataType (dListEnum TRUE FALSE)) (ValueType vLayer) (Status sProperty sCMEditOnly   ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_METAL_TO_METAL_SPC_VMODE)
  (Description "Any Metal to Any Metal Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases ADRC_MET_TO_MET_SPC_DIFF_NET_VMODE)
  (Version "16.3")
)
;---------------------
; 46.	Bond Finger to Package Substrate Spacing
;---------------------
( Attribute
  (Name ADRC_BOND_FNGR_TO_PACK_EDGE_SPC   )
  (Description "Minimum Required Bond Finger to Package Substrate Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_BOND_FNGR_TO_PACK_EDGE_SPC_VMODE)
  (Description "Bond Finger to Package Substrate Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 47.	Conductor to Package Substrate Spacing
;---------------------
( Attribute
  (Name ADRC_COND_TO_PACKAGE_EDGE_SPC   )
  (Description "Minimum Required Conductor to Package Substrate Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0))  (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_COND_TO_PACKAGE_EDGE_SPC_VMODE)
  (Description "Conductor to Package Substrate Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 48.	Exposed Metal To Exposed Metal Spacing
;---------------------
( Attribute
  (Name ADRC_EXP_METAL_TO_EXP_METAL_SPC   )
  (Description "Minimum Required Exposed Metal To Exposed Metal Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0))  (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_EXP_METAL_TO_EXP_METAL_SPC_VMODE)
  (Description "Exposed Metal To Exposed Metal Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 49.	Via to Package Substrate Spacing
;---------------------
( Attribute
  (Name ADRC_VIA_TO_PACKAGE_EDGE_SPC   )
  (Description "Minimum Required Via to Package Substrate Spacing.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (Range (Min 0.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_VIA_TO_PACKAGE_EDGE_SPC_VMODE)
  (Description "Via to Package Substrate Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;==================
; Miscellaneous Rules
; =================
;---------------------
; 50.	Cline to Via Overlap
;---------------------
( Attribute
  (Name ADRC_CLINE_TO_VIA_OVERLAP_VMODE)
  (Description "Cline to Via Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dAssembly)
  (Version "16.3")
) 
;---------------------
; 51.	Degassing Void Overlap
;---------------------
( Attribute
  (Name ADRC_DEGAS_VOID_OVERLAP_SPC  )
  (Description "Minimum Required Degassing Void Overlap Spacing. Use 0 for overlap only.")
  (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DEGAS_VOID_OVERLAP_SPC_VMODE)
  (Description "Degassing Void Overlap Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)

;---------------------
; 53.	Discrete Component Pad to Bond Finger Spacing
;---------------------

( Attribute
  (Name ADRC_DCR_COMP_PAD_BOND_FNGR_SPC  )
  (Description "Minimum Required Discrete Component Pad to Bond Finger Spacing.")
   (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DCR_COMP_PAD_BOND_FNGR_SPC_VMODE)
  (Description "Discrete Component Pad to Bond Finger Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 54.	Discrete Component Pad to Package Edge Spacing
;---------------------
( Attribute
  (Name ADRC_DCR_COMP_PAD_PACK_EDGE_SPC  )
  (Description "Minimum Required Discrete Component Pad to Package Edge Spacing.")
   (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_DCR_COMP_PAD_PACK_EDGE_SPC_VMODE)
  (Description "Discrete Component Pad to Package Edge Spacing Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 55.	Minimum Cline Segment
;---------------------
( Attribute
  (Name ADRC_MIN_CLINE_SEG_MIN_LEN )
  (Description "Minimum Required Cline Segment Length.")
  (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_MIN_CLINE_SEG_MIN_LEN_VMODE)
  (Description "Minimum Cline Segment Length Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 56.	Tombstone Check
;---------------------
( Attribute
  (Name ADRC_TOMBSTONE_CHECK_TOLERANCE  )
  (Description "Maximum Tolerance.")
  (Value (DataType (dDouble)) (Units uPercentage %) (ValueType vPercentage) (Range (Min 0.0)) (Status sProperty sCMEditOnly sNoUnitStr  ))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_TOMBSTONE_CHECK_TOLERANCE_VMODE)
  (Description "Tombstone Check Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.3")
)
;---------------------
; 57.	Trace Extension from Bond Finger
;---------------------
( Attribute
  (Name ADRC_CLINE_EXT_MIN_LEN  )
  (Description "Minimum Required Trace Extension Length.")
   (Value (DataType (dListDouble)) (Units uDesign mil) (ValueType vLayer) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_CLINE_EXT_ANGLE )
  (Description "Maximum Trace Angle To Bond Finger.")
  (Value (DataType (dListDouble)) (Units uAngle Degrees) (Range (Min 0.0) (Max 360.0)) (ValueType vLayer) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.3")
)
( Attribute
  (Name ADRC_CLINE_EXT_MIN_LEN_VMODE)
  (Description "Trace Extension from Bond Finger Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Aliases ADRC_CLINE_EXT_ANGLE_VMODE)
  (Version "16.3")
)
;==================
; Cavity Rules
; =================
;---------------------
; Bondfinger to Cavity Spacing
;---------------------
( Attribute
  (Name ADRC_FINGER_TO_CAVITY_SPC  )
  (Description "Minimum Required Bond Finger To Cavity Spacing.")
   (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)
( Attribute
  (Name ADRC_FINGER_TO_CAVITY_SPC_VMODE)
  (Description "Bond Finger To Cavity Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
;---------------------
; Component to Cavity Spacing
;---------------------
( Attribute
  (Name ADRC_COMPONENT_TO_CAVITY_SPC  )
  (Description "Minimum Required Component To Cavity Spacing.")
   (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)
( Attribute
  (Name ADRC_COMPONENT_TO_CAVITY_SPC_VMODE)
  (Description "Component To Cavity Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)



;---------------------
; Acute Angle Cavity Check
;---------------------
( Attribute
  (Name ADRC_ADRC_ACUTE_ANGLE_CAVITY  )
  (Description "Acute Angle Cavity Check.")
  (Value (DataType (dDouble)) (Units uAngle Degrees)  (Range (Min 0.0) (Max 90.0)) (Status sProperty sCMEditOnly sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)
( Attribute
  (Name ADRC_ADRC_ACUTE_ANGLE_CAVITY_VMODE)
  (Description "Acute Angle Cavity Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
;---------------------
; Minimum Cavity Size
;---------------------
( Attribute
  (Name ADRC_MIN_SIZE_CAVITY  )
  (Description "Minimum Required Cavity Size.")
   (Value (DataType (dDouble)) (Units uDesign mil) (Range (Min 0.0)) (Status sProperty sCMEditOnly   sNoUnitStr))
  (Objects (ValidObjects oDesign  oACSet) )
  (Version "16.6")
)
( Attribute
  (Name ADRC_MIN_SIZE_CAVITY_VMODE)
  (Description "Minimum Cavity Size Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Version "16.6")
)
;--------------------------------
; Object exposure in cavity check
;--------------------------------
( Attribute
  (Name ADRC_OBJECT_EXPOSURE_CAVITY_VMODE)
  (Description "Object Exposure to Cavity Verification Mode.")
  (Value (DataType (dEnum ON OFF)) (Status sProperty sVMode SControl))
  (Objects (ValidObjects oSystem oDesign))
  (Domains dAssembly)
  (Version "16.6")
)

;=============================
; ASSEMBLY DOMAIN PROPERTIES
; =================
; Wire Profile
; -----------------------
( Attribute
  (Name WIRE_PROF_DIAMETER)
  (Description "Wire Diameter")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sReadOnly sDerivedData))
  (Objects (ValidObjects oWireProfile))
  (Version "16.3")
)
( Attribute
  (Name WIRE_PROF_MATERIAL)
  (Description "Wire Material")
  (Value (DataType (dString)) (Status sReadOnly sDerivedData))
  (Objects (ValidObjects oWireProfile))
  (Version "16.3")
)
;------------------------
; Die Thickness and attachment type
; -----------------------
( Attribute
  (Name DIE_THICKNESS)
  (Description "Die Thickness")
  (Value (DataType (dDouble)) (Units uDesign mil) (Status sReadOnly sDerivedData))
  (Objects (ValidObjects oIODie oInterposer oSpacer))
  (Version "16.3")
)
( Attribute
  (Name DIE_ATTACHMENT_TYPE)
  (Description "Attachment Type")
  (Value (DataType (dString)) (Status sReadOnly sDerivedData))
  (Objects (ValidObjects oIODie oInterposer oSpacer))
  (Version "16.3")
)
;------------------------
; Interface Based Design
; -----------------------

; Misc attributes that were introduced.
;======================================
( Attribute
  (Name MEMBERSHIP_LOCKED)
  (Description "Lock the membership of an object")
  (Value (DataType (dEnum MODEL_DEFINED SCHEMATIC_DEFINED CODESIGN_DEFINED FSP_DEFINED LIBRARY_DEFINED SCHEMATIC_LIBRARAY_DEFINED NETGROUP_DEFINED)) (Status sProperty sNoEditor))
  (Objects (ValidObjects oNetInterface oNetGroup oRatBundle oFromTo oBus oDiffPair oNet oXnet))
  (Domains dNoDomain)  
  (Version "16.6")
)

; MAPPER: Attributes used to store mapping information.
; ====================================================
( Attribute
  (Name OBJECT_INSTANCE)
  (Description "Mapped object name")
  (Value (DataType (dString)) (ValueType vIBDMapping) (Status sProperty sObjectInstance sCMEditOnly sCMDefined sNoInherit))
  (Objects (ValidObjects oNetInterface oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name INTERFACE_DEFINITION)
  (Description "Interface Definition Name")
  (Value (DataType (dString)) (Status sProperty sNoEditor sCMEditOnly sNoInherit))
  (Objects (ValidObjects oNetInterface oNetGroup))
)
( Attribute
  (Name CDS_IBD_PRESENCE)
  (Description "If defined, the existance of the port is controlled by the specified value.")
  (Value (DataType (dEnum illegal required optional)) (ValueType vEnumSpecial) (Status sProperty sCMEditOnly sCanBeLocked))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_ALLOWABLE_SIZES)
  (Description "List of allowable sizes for replication of a port.  Absence indicates no restriction.")
  (Value (DataType (dListLong)) (Status sProperty sCMEditOnly sNoInherit sCanBeLocked))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SIZE)
  (Description "Defines the replication count of a port. The logical numbering of the port starts at 0 to size-1.")
  (Value (DataType (dLong)) (Range (Min 1)) (Status sProperty sCMEditOnly sNoInherit sCanBeLocked))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
  (PropertyToRestrict (fMatchOneOf CDS_IBD_ALLOWABLE_SIZES))
)
( Attribute
  (Name CDS_IBD_DIRECTION)
  (Description "If defined, the direction of a port is restricted to the specified value. ")
  (Value (DataType (dEnum in out inout)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_CONFIGURED)
  (Description "Flag an interface definition as expanded to meet a specific configuration.")
  (Value (DataType (dEnum expanded)) (Status sProperty sCMEditOnly sNoEditor))
  (Objects (ValidObjects oNetInterface))
)
( Attribute
  (Name CDS_IBD_INST_CONFIGURATION)
  (Description "Configuration information for an Interface instance.")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly sCMDefined sNoEditor))
  (Objects (ValidObjects oNetInterface))
)

; SPIRIT Vendor:Library:Name:Version (VLNV) element
; =================================================
( Attribute
  (Name CDS_IBD_VENDOR)
  (Description "Vendor which supports the Interface")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetInterface))
)
( Attribute
  (Name CDS_IBD_LIBRARY)
  (Description "Library name from which the Interface originates")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetInterface))
)
( Attribute
  (Name CDS_IBD_VERSION)
  (Description "Version of Interface")
  (Value (DataType (dDouble)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oDesign))
)

; SPIRIT Port element
; ===================
( Attribute
  (Name CDS_IBD_DISPLAY_NAME)
  (Description "Display name for Interface object")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oDiffPair oBus oXnet oNet))
)
( Attribute
  (Name CDS_IBD_DESC)
  (Description "Description of Interface object")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly sNoInherit))
  (Objects (ValidObjects oNetGroup oDiffPair oBus oXnet oNet))
)
; Port elements will contain a wire element.

; SPIRIT Qualifier element (optional within a wire element)
; ========================
( Attribute
  (Name CDS_IBD_QUALIFIER)
  (Description "Indicates the type of information a port will carry")
  (Value (DataType (dEnum Address Data Address_and_Data Clock Reset)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oDiffPair oBus oXnet oNet))
)

; SPIRIT onSystem element (optional within a wire element)
; =======================
( Attribute
  (Name CDS_IBD_SYS_GROUP_NAME)
  (Description "Used to group common/shared ports into different groups at the system-level")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oDiffPair oBus oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SYS_PRESENCE)
  (Description "Requirements of a common/shared port")
  (Value (DataType (dEnum illegal required optional)) (Status sProperty sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SYS_ALLOWABLE_SIZES)
  (Description "List of allowable sizes of a common/shared port.  Absence indicates no restriction.")
  (Value (DataType (dListLong)) (Status sProperty sCMEditOnly sNoInherit sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SYS_SIZE)
  (Description "Indicates the size of a common/shared port")
  (Value (DataType (dLong)) (Range (Min 1)) (Status sProperty sCMEditOnly sNoInherit sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
  (PropertyToRestrict (fMatchOneOf CDS_IBD_SYS_ALLOWABLE_SIZES))
)
( Attribute
  (Name CDS_IBD_SYS_DIRECTION)
  (Description "Indicates the direction of a common/shared port")
  (Value (DataType (dEnum in out inout)) (Status sProperty sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)

; SPIRIT onMaster element (optional within a wire element)
; =======================
( Attribute
  (Name CDS_IBD_MASTER_PRESENCE)
  (Description "If defined, the existance of the port is controlled by the specified value.")
  (Value (DataType (dEnum illegal required optional)) (Status sProperty sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_MASTER_ALLOWABLE_SIZES)
  (Description "List of allowable sizes for replication of a master port. Absence indicates no restriction.")
  (Value (DataType (dListLong)) (Status sProperty sCMEditOnly sNoInherit sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_MASTER_SIZE)
  (Description "Defines the replication count of a master port. Absence indicates size will be specified when interface is instantiated. The logical numbering of the port starts at 0 to size-1.")
  (Value (DataType (dLong)) (Range (Min 1)) (Status sProperty sCMEditOnly sNoInherit sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
  (PropertyToRestrict (fMatchOneOf CDS_IBD_MASTER_ALLOWABLE_SIZES))
)
( Attribute
  (Name CDS_IBD_MASTER_DIRECTION)
  (Description "If defined, the direction of a master port is restricted to the specified value. ")
  (Value (DataType (dEnum in out inout)) (Status sProperty sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)

; SPIRIT onSlave element (optional within a wire element)
; ======================
( Attribute
  (Name CDS_IBD_SLAVE_PRESENCE)
  (Description "Requirements of a slave port")
  (Value (DataType (dEnum illegal required optional)) (Status sProperty sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SLAVE_ALLOWABLE_SIZES)
  (Description "List of allowable sizes of a slave port.  Absence indicates no restriction.")
  (Value (DataType (dListLong)) (Status sProperty sCMEditOnly sNoInherit sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SLAVE_SIZE)
  (Description "Indicates the size of a slave port")
  (Value (DataType (dLong)) (Range (Min 1)) (Status sProperty sCMEditOnly sNoInherit sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
  (PropertyToRestrict (fMatchOneOf CDS_IBD_SLAVE_ALLOWABLE_SIZES))
)
( Attribute
  (Name CDS_IBD_SLAVE_DIRECTION)
  (Description "Indicates the direction of a slave port")
  (Value (DataType (dEnum in out inout)) (Status sProperty sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)

;==========================================================================================
; Attributes which can be used display a parent's name. Only child-parent releationships
; which are directly set can be displayed.

( Attribute
  (Name PARENT_CLASS)
  (Description "Object's Net Class")
  (Value (DataType (dString))(ValueType vEditOrPickFromList)(Status sControl sObjectParent sCMEditOnly sUpperCaseValue))
  (Objects (ValidObjects oBus oDiffPair oNet oXNet oNetGroup) (ParentObjects oNetClass))
  (Version "16.5")
)
;------------------------
; FSP
; -----------------------
( Attribute
  (Name CDS_FSP_NET)
  (Description "FSP Logical net name")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oNet oPin))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_INSTANCE_NAME)
  (Description "FSP instance reference designator")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_INSTANCE_ID)
  (Description "FSP instance object ID")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_LIB_PART_MODEL)
  (Description "FSP instance reference library and part name")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_IS_FPGA)
  (Description "FSP FPGA instance")
  (Value (DataType (dBoolean)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_UID)
  (Description "FSP unique net ID")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oNet oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_TERM_TYPE)
  (Description "FSP termination type")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_TERM_NAME)
  (Description "FSP termination name")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_MAPPED_CELL)
  (Description "FSP referenced front-end library and cell")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_TERM_INDEX)
  (Description "FSP termination ID")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)
( Attribute
  (Name CDS_FSP_FPGA_SYMBOL)
  (Description "Schematic symbol was generated by FSP")
  (Value (DataType (dString)) (Status sProperty sPackage sNoEditor))
  (Objects (ValidObjects oPart oGate))
  (Domains dNoDomain)  
  (Version "16.6")
)

)
