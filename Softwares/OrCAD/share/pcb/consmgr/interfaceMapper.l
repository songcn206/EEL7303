
(AttributeDictionary

( Attribute
  (Name CDS_IBD_OBJECT_NAME)
  (Description "Mapped object name")
  (Value (DataType (dString)) (ValueType vIBDMapping) (Status sProperty sInstances sCMEditOnly sCMDefined sNoInherit))
  (Objects (ValidObjects oNetInterface oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_OBJECT_KIND)
  (Description "Mapped object kind")
  (Value (DataType (dLong)) (Status sProperty sInstances sNoEditor sCMEditOnly sCMDefined sNoInherit))
  (Objects (ValidObjects oNetInterface oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_INTERFACE_NAME)
  (Description "Interface name object belongs to")
  (Value (DataType (dString)) (Status sProperty sHidden sNoInherit))
  (Objects (ValidObjects oNetInterface oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_INTERFACE_DEFN_NAME)
  (Description "Interface Definition Name")
  (Value (DataType (dString)) (Status sProperty sNoEditor sCMEditOnly sCMDefined sNoInherit))
  (Objects (ValidObjects oNetInterface))
)
( Attribute
  (Name CDS_IBD_PRESENCE)
  (Description "If defined, the existance of the port is controlled by the specified value.")
  (Value (DataType (dEnum illegal required optional)) (Status sProperty sCMEditOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_WIDTH)
  (Description "Defines the replication count of a port. The logical numbering of the port starts at 0 to width-1.")
  (Value (DataType (dLong)) (Range (Min 1)) (Status sProperty sCMEditOnly sNoInherit))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name CDS_IBD_DIRECTION)
  (Description "If defined, the direction of a port is restricted to the specified value. ")
  (Value (DataType (dEnum in out inout)) (Status sProperty sReadOnly sCMEditOnly sReadOnly))
  (Objects (ValidObjects oNetGroup oBus oDiffPair oXnet oNet))
)
( Attribute
  (Name COMMENT)
  (Description "Comment")
  (Value (DataType (dString)) (Status sProperty sNoInherit ))
  (Objects (ValidObjects oNetInterface oNetGroup oBus oDiffPair oXnet oNet))
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

)
