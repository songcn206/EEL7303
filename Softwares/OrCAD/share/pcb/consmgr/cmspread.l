; =STS=> cmspread.aa39.l   closed   SMID:39 
;
; NEXT HELP TAG = 32 
;
(SpreadsheetDescriptionFile
  (SpreadsheetDescriptionHeader
    (Version 97c)
  )
  (SpreadsheetDefinitions
    (Width 9)
    (EnumValueMappings
        (EnumAttribute EDGE_SENS
            (EnumConversion "RISING" "Rising")
            (EnumConversion "FALLING" "Falling")
            (EnumConversion "BOTH" "Both")
            (EnumConversion "NEITHER" "Neither")
        )
        (EnumAttribute FIRST_INCIDENT
            (EnumConversion "RISING" "Rising")
            (EnumConversion "FALLING" "Falling")
            (EnumConversion "BOTH" "Both")
            (EnumConversion "NEITHER" "Neither")
        )
        (EnumAttribute RELATIVE_SKEW_PATH_TYPE
            (EnumConversion "D:R" "Longest Driver/Receiver")
            (EnumConversion "AD:AR" "All Drivers/All Receivers")
        )
        (EnumAttribute PROPAGATION_DELAY_PATH_TYPE
            (EnumConversion "L:S" "Longest/Shortest Pin Pair")
            (EnumConversion "D:R" "Longest/Shortest Driver/Receiver")
            (EnumConversion "AD:AR" "All Drivers/All Receivers")
        )
        (EnumAttribute RELATIVE_PROPAGATION_DELAY_PATH_TYPE
            (EnumConversion "L:S" "Longest Pin Pair")
            (EnumConversion "D:R" "Longest Driver/Receiver")
            (EnumConversion "AD:AR" "All Drivers/All Receivers")
        )
        (EnumAttribute RATSNEST_SCHEDULE
            (EnumConversion "MIN_TREE" "Minimum Spanning Tree")
            (EnumConversion "MIN_DAISY_CHAIN" "Daisy-chain")
            (EnumConversion "SOURCE_LOAD_DAISY_CHAIN" "Source-load Daisy-chain")
            (EnumConversion "STAR" "Star")
            (EnumConversion "FAR_END_CLUSTER" "Far-end Cluster")
        )
        (EnumAttribute TOPOLOGY_TEMPLATE_MAPPING_MODE
            (EnumConversion "PINUSE" "Pinuse")
            (EnumConversion "REFDES" "Refdes")
            (EnumConversion "PINUSE_REFDES" "Pinuse and Refdes")
        )
        (EnumAttribute NET_SCHEDULE
            (EnumConversion "VERIFY" "Yes")
            (EnumConversion "DO_NOT_VERIFY" "No")
        )
        (EnumAttribute RELATIVE_PROPAGATION_DELAY_SCOPE
            (EnumConversion "L" "Local")
            (EnumConversion "G" "Global")
        )
        (EnumAttribute RELATIVE_SKEW_SCOPE
            (EnumConversion "L" "Local")
            (EnumConversion "G" "Global")
        )
    )
    (ObjectType "Electrical Constraint Set"
        (HelpTag 1)
        (EnableObject "Design")
        (EnableObject "ConstraintSet")
        (Discipline "Signal Integrity"
          (HelpTag 2)
          (Tab "Reflection/Edge Distortions"
                (Column "Objects")
                (ColumnHeader "Reflection"
                    (Column "Overshoot" (Attribute MAX_OVERSHOOT) (Width 12) )
                    (Column "Min Noise Margin" (Attribute MIN_NOISE_MARGIN) (Width 12) )
                )
                (ColumnHeader "Edge Distortions"
                    (Column "Edge Sensitivity" (Attribute EDGE_SENS) (Width 9) )
                    (Column "First Incident Switch" (Attribute FIRST_INCIDENT) (Width 9) )
                )
                (HelpTag 3)
          )
          (Tab "Xtalk/SSN"
                (Column "Objects")
                (ColumnHeader "Xtalk"
                    (Column "Active Xtalk Window" (Attribute XTALK_ACTIVE_TIME) (Width 12) )
                    (Column "Sensitive Xtalk Window" (Attribute XTALK_SENSITIVE_TIME) (Width 12) )
                    (Column "Max Xtalk" (Attribute MAX_XTALK) (Width 12) )
                    (Column "Max Peak Xtalk" (Attribute MAX_PEAK_XTALK) (Width 12) )
				)
                (Column "Max SSN" (Attribute MAX_SSN) (Width 12) )
                (HelpTag 4)
          )
        )
        (Discipline "Timing"
          (HelpTag 5)
          (Tab "Switch/Settle Delays"
                (EnableObject "DelayECSetPinPair")
                (Column "Objects")
                (Column "Min First Switch" (Attribute MIN_FIRST_SWITCH) (Width 12) )
                (Column "Max Final Settle" (Attribute MAX_FINAL_SETTLE) (Width 12) )
                (HelpTag 6)
          )
        )
        (Discipline "Routing"
          (HelpTag 7)
          (Tab "Wiring"
                (Column "Objects")
                (ColumnHeader "Topology"
                    (Column "Mapping Mode" (Attribute TOPOLOGY_TEMPLATE_MAPPING_MODE) (Width 14) )
                    (Column "Verify Schedule" (Attribute NET_SCHEDULE) (Width 8) )
                    (Column "Schedule" (Attribute RATSNEST_SCHEDULE) (Width 12) )
                )
                (Column "Stub Length" (Attribute STUB_LENGTH) (Width 9) )
                (Column "Max Via Count" (Attribute MAX_VIA_COUNT) (Width 9) )
                (Column "Max Exposed Length" (Attribute MAX_EXPOSED_LENGTH) (Width 9) )
                (Column "Max Parallel" (Attribute MAX_PARALLEL) (Width 12) )
                (HelpTag 8)
          )
          (Tab "Impedance"
                (EnableObject "ImpedanceECSetPinPair")
                (Column "Objects")
                (ColumnHeader "Impedance"
                    (Column "Target" (Attribute IMPEDANCE_RULE_VAL) (Width 12) )
                    (Column "Tolerance" (Attribute IMPEDANCE_RULE_TOL) (Width 12) )
                )
                (HelpTag 9)
          )
          (Tab "Min/Max Propagation Delays"
                (EnableObject "PropECSetPinPair")
                (Column "Objects")
                (Column "Pin Pairs" (Attribute PROPAGATION_DELAY_PATH_TYPE) (Width 18) )
                (Column "Min Delay" (Attribute PROPAGATION_DELAY_MIN) (Width 9) )
                (Column "Max Delay" (Attribute PROPAGATION_DELAY_MAX) (Width 9) )
                (HelpTag 10)
          )
          (Tab "Total Etch Length"
                (Column "Objects")
                (Column "Minimum Total Etch" (Attribute TOTAL_ETCH_LENGTH_MIN) (Width 15) )
                (Column "Maximum Total Etch" (Attribute TOTAL_ETCH_LENGTH_MAX) (Width 15) )
                (HelpTag 31)
          )
          (Tab "Relative Propagation Delay"
                (EnableObject "ECSetMatchGroup")
                (EnableObject "MatchECSetPinPair")
                (Column "Objects")
                (Column "Pin Pairs" (Attribute RELATIVE_PROPAGATION_DELAY_PATH_TYPE) (Width 18) )
                (Column "Scope" (Attribute RELATIVE_PROPAGATION_DELAY_SCOPE) (Width 9) )
                (Column "Delta:Tolerance" (Attribute RELATIVE_PROPAGATION_DELAY) (Width 20) )
                (HelpTag 11)
          )
       )
       (Discipline "All Constraints"
          (HelpTag 12)
          (Tab "Signal Integrity/Timing/Routing"
                (EnableObject "DelayECSetPinPair")
                (EnableObject "ECSetMatchGroup")
                (EnableObject "SkewECSetPinPair")
                (EnableObject "ImpedanceECSetPinPair")
                (EnableObject "PropECSetPinPair")
                (EnableObject "ECSetMatchGroup")
                (EnableObject "MatchECSetPinPair")
                (Column "Objects")
                (ColumnHeader "Reflection"
                    (Column "Overshoot" (Attribute MAX_OVERSHOOT) (Width 12) )
                    (Column "Min Noise Margin" (Attribute MIN_NOISE_MARGIN) (Width 14) )
                )
                (ColumnHeader "Edge Distortions"
                    (Column "Sensitivity" (Attribute EDGE_SENS) (Width 9) )
                    (Column "First Incident" (Attribute FIRST_INCIDENT) (Width 9) )
                )
                (ColumnHeader "Xtalk"
                    (Column "Active Window" (Attribute XTALK_ACTIVE_TIME) (Width 12) )
                    (Column "Sensitive Window" (Attribute XTALK_SENSITIVE_TIME) (Width 12) )
                    (Column "Max " (Attribute MAX_XTALK) (Width 12) )
                    (Column "Max Peak" (Attribute MAX_PEAK_XTALK) (Width 12) )
                )
                (Column "Max SSN" (Attribute MAX_SSN) (Width 12) )
                (ColumnHeader "Switch/Settle Delays"
                    (Column "Min First Switch" (Attribute MIN_FIRST_SWITCH) (Width 13) )
                    (Column "Max Final Settle" (Attribute MAX_FINAL_SETTLE) (Width 13) )
                )
                (ColumnHeader "Topology"
                    (Column "Mapping Mode" (Attribute TOPOLOGY_TEMPLATE_MAPPING_MODE) (Width 14) )
                    (Column "Verify Schedule" (Attribute NET_SCHEDULE) (Width 8) )
                    (Column "Schedule" (Attribute RATSNEST_SCHEDULE) (Width 12) )
                )
                (ColumnHeader "Wiring"
                    (Column "Stub Length" (Attribute STUB_LENGTH) (Width 10) )
                    (Column "Max Via Count" (Attribute MAX_VIA_COUNT) (Width 10) )
                    (Column "Max Exposed Length" (Attribute MAX_EXPOSED_LENGTH) (Width 10) )
                    (Column "Max Parallel" (Attribute MAX_PARALLEL) (Width 14) )
                )
                (ColumnHeader "Impedance"
                    (Column "Target" (Attribute IMPEDANCE_RULE_VAL) (Width 12) )
                    (Column "Tolerance" (Attribute IMPEDANCE_RULE_TOL) (Width 12) )
                )
                (ColumnHeader "Propagation Delay"
                    (Column "Pin Pairs" (Attribute PROPAGATION_DELAY_PATH_TYPE) (Width 18) )
                    (Column "Min" (Attribute PROPAGATION_DELAY_MIN) (Width 9) )
                    (Column "Max" (Attribute PROPAGATION_DELAY_MAX) (Width 9) )
                )
                (ColumnHeader "Total Etch Length"
                   (Column "Min" (Attribute TOTAL_ETCH_LENGTH_MIN) (Width 9) )
                   (Column "Max" (Attribute TOTAL_ETCH_LENGTH_MAX) (Width 9) )
				)
                (ColumnHeader "Relative Propagation Delay"
                    (Column "Pin Pairs" (Attribute RELATIVE_PROPAGATION_DELAY_PATH_TYPE) (Width 18) )
                    (Column "Scope" (Attribute RELATIVE_PROPAGATION_DELAY_SCOPE) (Width 9) )
                    (Column "Delta:Tolerance" (Attribute RELATIVE_PROPAGATION_DELAY) (Width 20) )
                )
                (HelpTag 13)
          )
       )
    )
    (ObjectType "Net"
        (HelpTag 14)
        (EnableMode "Implementation")
        (EnableObject "Design")
        (EnableObject "Net")
        (EnableObject "XNet")
        (EnableObject "Bus")
        (EnableObject "DiffPair")
        (Discipline "Signal Integrity"
          (HelpTag 15)
          (Tab "Electrical Properties"
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (Column "Frequency" (Attribute PULSE_PARAM_FREQ) (Width 10) )
                (Column "Period" (Attribute PULSE_PARAM_PERIOD) (Width 10) )
                (Column "Duty Cycle" (Attribute  PULSE_PARAM_DUTY_CYCLE) (Width 10) )
                (Column "Jitter" (Attribute PULSE_PARAM_JITTER) (Width 10) )
                (Column "Cycle to Measure" (Attribute PULSE_PARAM_MEASURE_CYCLE) (Width 10) )
                (HelpTag 16)
          )
          (Tab "Reflection"
                (EnableObject "ReflectionResult")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (ColumnHeader "Overshoot"
                     (Column "Max" (Attribute MAX_OVERSHOOT) (Width 12) )
                     (Column "High Actual" (Attribute MAX_OVERSHOOT_ACTUAL.0) (Width 10) )
                     (Column "Low Actual" (Attribute MAX_OVERSHOOT_ACTUAL.1) (Width 10) )
                     (Column "Margin" (Attribute MAX_OVERSHOOT_MARGIN) (Width 6) )
                )
                (ColumnHeader "Noise Margin"
                    (Column "Min" (Attribute MIN_NOISE_MARGIN) (Width 12) )
                    (Column "High Actual" (Attribute MIN_NOISE_MARGIN_ACTUAL.0) (Width 10) )
                    (Column "Low Actual" (Attribute MIN_NOISE_MARGIN_ACTUAL.1) (Width 10) )
                    (Column "Margin" (Attribute MIN_NOISE_MARGIN_MARGIN) (Width 6) )
                )
                (HelpTag 17)
          )
          (Tab "Edge Distortions"
                (EnableObject "DistortionResult")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (ColumnHeader "Edge Sensitivity"
                    (Column "Sensitive Edge" (Attribute EDGE_SENS) (Width 9) )
                    (Column "Rise Actual" (Attribute EDGE_SENS_ACTUAL.0) (Width 10) )
                    (Column "Fall Actual" (Attribute EDGE_SENS_ACTUAL.1) (Width 10) )
                    (Column "Margin" (Attribute EDGE_SENS_MARGIN) (Width 9) )
                )
                (ColumnHeader "First Incident Switch"
                    (Column "Switch" (Attribute FIRST_INCIDENT) (Width 9) )
                    (Column "Rise Actual" (Attribute FIRST_INCIDENT_ACTUAL.0) (Width 10) )
                    (Column "Fall Actual" (Attribute FIRST_INCIDENT_ACTUAL.1) (Width 10) )
                    (Column "Margin" (Attribute FIRST_INCIDENT_MARGIN) (Width 9) )
                )
                (HelpTag 18)
          )
          (Tab "Estimated Xtalk"
                (EnableObject "EstXtalkResult")
                (EnableObject "EstPeakXtalkResult")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (Column "Active Window" (Attribute XTALK_ACTIVE_TIME) (Width 12) )
                (Column "Sensitive Window" (Attribute XTALK_SENSITIVE_TIME)  (Width 12))
                (Column "Ignore Nets" (Attribute XTALK_IGNORE_NETS) (Width 12) )
                (ColumnHeader "Xtalk"
                    (Column "Max" (Attribute MAX_XTALK_EST) (Width 12) )
                    (Column "Actual" (Attribute MAX_XTALK_EST_ACTUAL) (Width 10) )
                    (Column "Margin" (Attribute MAX_XTALK_EST_MARGIN) (Width 6) )
				)
                (ColumnHeader "Peak Xtalk"
                    (Column "Max" (Attribute MAX_PEAK_XTALK_EST) (Width 12) )
                    (Column "Actual" (Attribute MAX_PEAK_XTALK_EST_ACTUAL) (Width 10) )
                    (Column "Margin" (Attribute MAX_PEAK_XTALK_EST_MARGIN) (Width 6) )
			    )
                (HelpTag 19)
          )
          (Tab "Simulated Xtalk"
                (EnableObject "XtalkResult")
                (EnableObject "PeakXtalkResult")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (Column "Active Window" (Attribute XTALK_ACTIVE_TIME) (Width 12) )
                (Column "Sensitive Window" (Attribute XTALK_SENSITIVE_TIME)  (Width 12))
                (Column "Ignore Nets" (Attribute XTALK_IGNORE_NETS) (Width 12) )
                (ColumnHeader "Xtalk"
                    (Column "Max" (Attribute MAX_XTALK) (Width 12) )
                    (Column "Actual" (Attribute MAX_XTALK_ACTUAL) (Width 10) )
                    (Column "Margin" (Attribute MAX_XTALK_MARGIN) (Width 6) )
				)
                (ColumnHeader "Peak Xtalk"
                    (Column "Max" (Attribute MAX_PEAK_XTALK) (Width 12) )
                    (Column "Actual" (Attribute MAX_PEAK_XTALK_ACTUAL) (Width 10) )
                    (Column "Margin" (Attribute MAX_PEAK_XTALK_MARGIN) (Width 6) )
			    )
                (HelpTag 20)
          )
          (Tab "SSN"
                (EnableObject "SSNResult")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (Column "Max SSN" (Attribute MAX_SSN) (Width 12) )
                (Column "Power Bus Name" (Attribute MAX_SSN_POWER_BUS) (Width 12) )
                (Column "Ground Bus Name" (Attribute MAX_SSN_GROUND_BUS) (Width 12) )
                (Column "Actual" (Attribute MAX_SSN_ACTUAL) (Width 10) )
                (Column "Margin" (Attribute MAX_SSN_MARGIN) (Width 6) )
                (HelpTag 21)
          )
        )
        (Discipline "Timing"
          (HelpTag 22)
          (Tab "Switch/Settle Delays"
                (EnableObject "DelayPinPair")
                (EnableObject "DelayResult")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (ColumnHeader "Min First Switch"
                     (Column "Min" (Attribute MIN_FIRST_SWITCH) (Width 12) )
                     (Column "Rise Actual" (Attribute MIN_FIRST_SWITCH_ACTUAL.0) (Width 10) )
                     (Column "Fall Actual" (Attribute MIN_FIRST_SWITCH_ACTUAL.1) (Width 10) )
                     (Column "Margin" (Attribute MIN_FIRST_SWITCH_MARGIN) (Width 6) )
                )
                (ColumnHeader "Max Final Settle"
                    (Column "Max" (Attribute MAX_FINAL_SETTLE) (Width 12) )
                    (Column "Rise Actual" (Attribute MAX_FINAL_SETTLE_ACTUAL.0) (Width 10) )
                    (Column "Fall Actual" (Attribute MAX_FINAL_SETTLE_ACTUAL.1) (Width 10) )
                    (Column "Margin" (Attribute MAX_FINAL_SETTLE_MARGIN) (Width 6) )
                )
                (HelpTag 23)
          )
          (Tab "Setup/Hold"
                (EnableObject "TimingPinPair")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (ColumnHeader "Clock"
                    (Column "Name" (Attribute CLOCK_NET) (Width 9) )
                    (Column "Period" (Attribute PULSE_PARAM_PERIOD) (Width 6) (AlternateQuery CLOCK) )
                    (Column "Jitter" (Attribute PULSE_PARAM_JITTER) (Width 6) (AlternateQuery CLOCK) )
                )
                (ColumnHeader "Clock 2Out"
                    (Column "Min" (Attribute CLK_2OUT_MIN)  (Width 6))
                    (Column "Max" (Attribute CLK_2OUT_MAX)  (Width 6))
                )
                (ColumnHeader "Clock Skew"
                    (Column "Min" (Attribute CLK_SKEW_MIN) (Width 6) )
                    (Column "Max" (Attribute CLK_SKEW_MAX) (Width 6) )
                )
                (ColumnHeader "Interconnect Delay"
                    (Column "First Switch" (Attribute MIN_FIRST_SWITCH_ACTUAL) (Width 10) )
                    (Column "Final Settle" (Attribute MAX_FINAL_SETTLE_ACTUAL) (Width 10) )
                    (Column "Override" (Attribute TIMING_DELAY_OVERRIDE) (Width 9) )
                )
				(StartEnv CM_USE_GUARDBAND)
                (Column "Tester Guardband" (Attribute TESTER_GUARDBAND) (Width 9) )
				(EndEnv CM_USE_GUARDBAND)
                (ColumnHeader "Setup"
                    (Column "Min" (Attribute MIN_SETUP) (Width 6) )
                    (Column "Actual" (Attribute MIN_SETUP_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute MIN_SETUP_MARGIN) (Width 6) )
                )
                (ColumnHeader "Hold"
                    (Column "Min" (Attribute MIN_HOLD) (Width 6) )
                    (Column "Actual" (Attribute MIN_HOLD_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute MIN_HOLD_MARGIN) (Width 6) )
                )
               (HelpTag 24)
          )
        )
        (Discipline "Routing"
          (HelpTag 25)
          (Tab "Wiring"
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (ColumnHeader "Topology"
                    (Column "Verify Schedule" (Attribute NET_SCHEDULE) (Width 6) )
                    (Column "Schedule" (Attribute RATSNEST_SCHEDULE) (Width 12) )
                    (Column "Actual" (Attribute RATSNEST_SCHEDULE_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute RATSNEST_SCHEDULE_MARGIN) (Width 6) )
                )
                (ColumnHeader "Stub Length"
                    (Column "Max" (Attribute STUB_LENGTH) (Width 6) )
                    (Column "Actual" (Attribute STUB_LENGTH_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute STUB_LENGTH_MARGIN) (Width 6) )
                )
                (ColumnHeader "Via Count"
                    (Column "Max" (Attribute MAX_VIA_COUNT) (Width 6) )
                    (Column "Actual" (Attribute MAX_VIA_COUNT_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute MAX_VIA_COUNT_MARGIN) (Width 6) )
                )
                (ColumnHeader "Exposed Length"
                    (Column "Max" (Attribute MAX_EXPOSED_LENGTH) (Width 6) )
                    (Column "Actual" (Attribute MAX_EXPOSED_LENGTH_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute MAX_EXPOSED_LENGTH_MARGIN) (Width 6) )
                )
                (ColumnHeader "Parallel"
                    (Column "Max" (Attribute MAX_PARALLEL) (Width 12) )
                    (Column "Actual" (Attribute MAX_PARALLEL_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute MAX_PARALLEL_MARGIN) (Width 6) )
                )
                (HelpTag 26)
          )
          (Tab "Impedance"
                (EnableObject "ImpedancePinPair")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (ColumnHeader "Impedance"
                    (Column "Target" (Attribute IMPEDANCE_RULE_VAL) (Width 6) )
                    (Column "Tolerance" (Attribute IMPEDANCE_RULE_TOL) (Width 7) )
                    (Column "Actual" (Attribute IMPEDANCE_RULE_ACTUAL) (Width 6) )
                    (Column "Margin" (Attribute IMPEDANCE_RULE_MARGIN) (Width 6) )
                )
                (HelpTag 27)
          )
          (Tab "Min/Max Propagation Delays"
                (EnableObject "PropPinPair")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (Column "Pin Pairs" (Attribute PROPAGATION_DELAY_PATH_TYPE)  (Width 18) )
                (ColumnHeader "Prop Delay"
                    (Column "Min" (Attribute PROPAGATION_DELAY_MIN) (Width 7) )
                    (Column "Actual" (Attribute PROPAGATION_DELAY_MIN_ACTUAL) (Width 7) )
                    (Column "Margin" (Attribute PROPAGATION_DELAY_MIN_MARGIN) (Width 7) )
                )
                (ColumnHeader "Prop Delay"
                    (Column "Max" (Attribute PROPAGATION_DELAY_MAX) (Width 7) )
                    (Column "Actual" (Attribute PROPAGATION_DELAY_MAX_ACTUAL) (Width 7) )
                    (Column "Margin" (Attribute PROPAGATION_DELAY_MAX_MARGIN) (Width 7) )
                )
                (HelpTag 28)
          )
          (Tab "Total Etch Length"
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (ColumnHeader "Total Etch Length"
                    (Column "Min" (Attribute TOTAL_ETCH_LENGTH_MIN) (Width 7) )
                    (Column "Actual" (Attribute TOTAL_ETCH_LENGTH_MIN_ACTUAL) (Width 7) )
                    (Column "Margin" (Attribute TOTAL_ETCH_LENGTH_MIN_MARGIN) (Width 7) )
                )
                (ColumnHeader "Total Etch Length"
                    (Column "Max" (Attribute TOTAL_ETCH_LENGTH_MAX) (Width 7) )
                    (Column "Actual" (Attribute TOTAL_ETCH_LENGTH_MAX_ACTUAL) (Width 7) )
                    (Column "Margin" (Attribute TOTAL_ETCH_LENGTH_MAX_MARGIN) (Width 7) )
                )
                (Column "Unrouted Net Length" (Attribute UNROUTED_LENGTH_ACTUAL) (Width 14) )
                (Column "Routed/Unrouted Ratio" (Attribute PERCENT_MANHATTAN_ACTUAL) (Width 16) )
                (HelpTag 29)
		  )
          (Tab "Relative Propagation Delay"
                (EnableObject "MatchGroup")
                (EnableObject "MatchPinPair")
                (EnableObject "MatchResult")
                (Column "Objects")
                (Column "Referenced Electrical CSet" (Attribute "ECSET_REF") (Width 2) )
                (Column "Pin Pairs" (Attribute RELATIVE_PROPAGATION_DELAY_PATH_TYPE) (Width 18) )
                (Column "Scope" (Attribute RELATIVE_PROPAGATION_DELAY_SCOPE) (Width 9) )
                (ColumnHeader "Relative Delay"
                    (Column "Delta:Tolerance" (Attribute RELATIVE_PROPAGATION_DELAY) (Width 20) )
                    (Column "Actual" (Attribute RELATIVE_PROPAGATION_DELAY_ACTUAL) (Width 9) )
                    (Column "Margin" (Attribute RELATIVE_PROPAGATION_DELAY_MARGIN) (Width 9) )
				)
                (Column "Length" (Attribute RELATIVE_PROPAGATION_OBJECT_LENGTH) (Width 10) )
                (HelpTag 30)
          )
       )
    )
  )
)
