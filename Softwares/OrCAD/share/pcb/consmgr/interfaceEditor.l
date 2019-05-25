
(AttributeDictionary

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
  (Value (DataType (dString)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oDiffPair oBus oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SYS_PRESENCE)
  (Description "Requirements of a common/shared port")
  (Value (DataType (dEnum illegal required optional)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SYS_ALLOWABLE_SIZES)
  (Description "List of allowable sizes of a common/shared port.  Absence indicates no restriction.")
  (Value (DataType (dListLong)) (Status sProperty sCMEditOnly sNoInherit))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SYS_DIRECTION)
  (Description "Indicates the direction of a common/shared port")
  (Value (DataType (dEnum in out inout)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)

; SPIRIT onMaster element (optional within a wire element)
; =======================
( Attribute
  (Name CDS_IBD_MASTER_PRESENCE)
  (Description "If defined, the existance of the port is controlled by the specified value.")
  (Value (DataType (dEnum illegal required optional)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_MASTER_ALLOWABLE_SIZES)
  (Description "List of allowable sizes for replication of a master port. Absence indicates no restriction.")
  (Value (DataType (dListLong)) (Status sProperty sCMEditOnly sNoInherit))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_MASTER_DIRECTION)
  (Description "If defined, the direction of a master port is restricted to the specified value. ")
  (Value (DataType (dEnum in out inout)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)

; SPIRIT onSlave element (optional within a wire element)
; ======================
( Attribute
  (Name CDS_IBD_SLAVE_PRESENCE)
  (Description "Requirements of a slave port")
  (Value (DataType (dEnum illegal required optional)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SLAVE_ALLOWABLE_SIZES)
  (Description "List of allowable sizes of a slave port.  Absence indicates no restriction.")
  (Value (DataType (dListLong)) (Status sProperty sCMEditOnly sNoInherit))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_SLAVE_DIRECTION)
  (Description "Indicates the direction of a slave port")
  (Value (DataType (dEnum in out inout)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)

; Standard Allegro attributes
; ===========================
( Attribute
  (Name VOLTAGE)
  (Description "Voltage level supported by interface")
  (Value (DataType (dString)) (Units uVoltage V) (Status sProperty sIgnoreConversion sNoUnitStr))
  (Objects (ValidObjects oVoltageDefinition))
)
( Attribute
  (Name COMMENT)
  (Description "Comment")
  (Value (DataType (dString)) (Status sProperty sNoInherit ))
  (Objects (ValidObjects oNetInterface oNetGroup oBus oDiffPair oXnet oNet oVoltageDefinition))
)
( Attribute
  (Name CLOCK_NET)
  (Description "Clock net name")
  (Value (DataType (dString)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Attribute
  (Name ELECTRICAL_CONSTRAINT_SET)
  (Description "Electrical Constraint Set reference")
  (Value (DataType (dEnum nil)) (ValueType vEnumSpecial) (Status sConstraint sCMEditOnly sHidden sRelation))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (RelatedProperties ECSET_MAPPING_ERROR ECSET_MAPPING_ERROR_MARGIN)
  (Domains dElectrical)
)
( Attribute
  (Name NET_ELECTRICAL_TYPE)
  (Description "Name of Electrical Net Class (NET_ELECTRICAL_TYPE)")
  (Value (DataType (dString)) (ValueType vEditOrPickFromList) (Status sProperty sUpperCaseValue))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
  (Version "15.2")
)
( Attribute
  (Name NET_PHYSICAL_TYPE)
  (Description "Name of Physical Net Class (NET_PHYSICAL_TYPE)")
  (Value (DataType (dString)) (ValueType vEditOrPickFromList) (Status sProperty sUpperCaseValue))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
  (Version "15.2")
)
( Attribute
  (Name NET_SPACING_TYPE)
  (Description "Name of Spacing Net Class (NET_SPACING_TYPE)")
  (Value (DataType (dString)) (ValueType vEditOrPickFromList) (Status sProperty sUpperCaseValue))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
  (Version "15.2")
)
( Attribute
  (Name PARENT_CLASS)
  (Description "Object's Net Class")
  (Value (DataType (dString))(ValueType vEditOrPickFromList)(Status sControl sObjectParent sCMEditOnly sUpperCaseValue))
  (Objects (ValidObjects oBus oDiffPair oNet oXNet oNetGroup) (ParentObjects oNetClass))
  (Version "16.5")
)
; Electrical Properties Tab
; -------------------------
( Attribute
  (Name PULSE_PARAM_FREQ)
  (Description "Nets switch frequency")
  (Value (DataType (dDouble)) (Units uFrequency MHz) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
;*******************
;Period should never be updated. Period is used to display the time
;domain value for PULSE_PARAM_FREQ which stores the actual value.
;*******************
( Attribute
  (Name PULSE_PARAM_PERIOD)
  (Description "Clock period" )
  (Value (DataType (dDouble)) (Units uTime ns) (Range (Min 0.0)) (Status sProperty sHidden sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Attribute
  (Name PULSE_PARAM_DUTY_CYCLE)
  (Description "Clock duty cycle expressed as a percentage for the time High")
  (Value (DataType (dLong)) (Units uPercentage %) (ValueType vPercentage) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Attribute
  (Name PULSE_PARAM_JITTER)
  (Description "Amount of clock jitter expressed as an absolute value")
  (Value (DataType (dDouble)) (Units uJitterTime ps) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Attribute
  (Name PULSE_PARAM_MEASURE_CYCLE)
  (Description "Clock cycle for measuring during simulation")
  (Value (DataType (dLong)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Attribute
  (Name PULSE_PARAM_COFF)
  (Description "Amount of clock jitter expressed as an absolute value")
  (Value (DataType (dDouble)) (Units uTime ns) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Attribute
  (Name PULSE_PARAM_AOFF)
  (Description "Amount of clock jitter expressed as an absolute value")
  (Value (DataType (dDouble)) (Units uTime ns) (Range (Min 0.0)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Attribute
  (Name PULSE_PARAM_BPAT)
  (Description "Bit Pattern")
  (Value (DataType (dString)) (ValueType vBitPattern) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetClass oNetGroup oBus oDiffPair oXnet oNet))
  (Domains dElectrical)
)
( Bundle
  (Name PULSE_PARAM)
  (Value (ValueType vPulseParam))
  (RelatedProperties PULSE_PARAM_FREQ PULSE_PARAM_DUTY_CYCLE PULSE_PARAM_JITTER PULSE_PARAM_MEASURE_CYCLE PULSE_PARAM_BPAT PULSE_PARAM_COFF PULSE_PARAM_AOFF)
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

)
