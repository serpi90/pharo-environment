StartupPreferencesLoader default executeAtomicItems:
  {
    (StartupAction
      name: 'Set author name'
      code: [ | properties |
        properties := FileStream readOnlyFileNamed: 'user-properties' do: [:file | STONJSON fromString: file contentsOfEntireFile ].
        Author fullName: (properties at: #author) ]
      runOnce: true).

    (StartupAction
      name: 'Setup fonts'
      code: [ | properties |
        properties := FileStream readOnlyFileNamed: 'user-properties' do: [:file | STONJSON fromString: file contentsOfEntireFile ].
        properties at: #fonts ifPresent: [:fonts| | default code |
            fonts at: #default ifPresent: [:font |
              StandardFonts defaultFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) forceNotBold.
              GraphicFontSettings resetAllFontToDefault.
              "It does weird things if we leave windowTitleFont bold but with same familyName and size so we use size + 1"
              StandardFonts windowTitleFont: (LogicalFont familyName: (font at: #name) pointSize: ((font at: #size)+1)) forceBold.
            ].
            fonts at: #code ifPresent: [:font | StandardFonts codeFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) ] ].
         ]
      runOnce: true).

    (StartupAction
      name: 'Set up UI theme'
      code: [ | properties |
        properties := FileStream readOnlyFileNamed: 'user-properties' do: [:file | STONJSON fromString: file contentsOfEntireFile ].
        properties at: #theme ifPresent: [:theme | Smalltalk at: theme asSymbol ifPresent: [:themeClass | themeClass beCurrent ] ]
        ]
      runOnce: true).

     (StartupAction
      name: 'Set up syntax highlighting style'
      code: [ | properties |
        properties := FileStream readOnlyFileNamed: 'user-properties' do: [:file | STONJSON fromString: file contentsOfEntireFile ].
        properties at: #sytaxTheme ifPresent: [:theme | SHPreferences setStyleTableNamed: theme ]
        ]
      runOnce: true).

    (StartupAction
      name: 'Debugger options'
      code: [ Smalltalk tools debugger alwaysOpenFullDebugger: true ]
      runOnce: true).

    (StartupAction
      name: 'Code formatting options'
      code: [
        BIConfigurableFormatter
          newLinesAfterTemporaries: 2;
          newLinesAfterMethodPattern: 2;
          retainBlankLinesBetweenStatements: true;
          newLineBeforeFirstCascade: false;
          newLineBeforeFirstCascade: true;
          yourself ]
      runOnce: true).

    (StartupAction
      name: 'Upgrade FPS to 60'
      code: [ WorldState MinCycleLapse: 16 ]
      runOnce: true).

    (StartupAction
      name: 'Completion options'
      code: [ NECPreferences caseSensitive: false ]
      runOnce: true).

    (StartupAction
      name: 'Show any startup action errors'
      code: [ StartupPreferencesLoader default errors ifNotEmpty: [ :errors | errors explore ] ]
      runOnce: true).

  }
