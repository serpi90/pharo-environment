[ | userProperties |
  StartupPreferencesLoader default executeAtomicItems:
  {
    (StartupAction
      name: 'Load User Properties'
      code: [ userProperties := STONJSON fromString: 'user-properties' asFileReference contents ]).

    (StartupAction
      name: 'Set author name'
      code: [ Author fullName: (userProperties at: #author) ]
      runOnce: true).

    (StartupAction
      name: 'Set fulscreen status'
      code: [ userProperties at: #fullscreen ifPresent: [ :boolean | Display fullscreenOff; fullscreen: boolean ] ]
      runOnce: false).

    (StartupAction
      name: 'Setup fonts'
      code: [ userProperties at: #fonts ifPresent: [ :fonts |
            fonts at: #default ifPresent: [ :font |
                StandardFonts defaultFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) forceNotBold.
                GraphicFontSettings resetAllFontToDefault.
                "It does weird things if we leave windowTitleFont bold but with same familyName and size so we use size + 1"
                StandardFonts windowTitleFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size) + 1) forceBold ].
            fonts at: #code ifPresent: [ :font | StandardFonts codeFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) ] ] ]).

    (StartupAction
      name: 'Set up UI theme'
      code: [ userProperties at: #theme ifPresent: [ :theme | Smalltalk at: theme asSymbol ifPresent: [ :themeClass | themeClass beCurrent ] ] ]
      runOnce: true).

    (StartupAction
      name: 'Set up syntax highlighting style'
      code: [ userProperties at: #sytaxTheme ifPresent: [ :theme | SHPreferences setStyleTableNamed: theme ] ]
      runOnce: true).

    (StartupAction
      name: 'Set iceberg shared repository'
      code: [ userProperties at: 'iceberg' ifPresent: [:icebergConfig |
        icebergConfig
          at: 'sharedDirectory' ifPresent: [:path | IceRepository shareRepositoriesBetweenImages: true; sharedRepositoriesLocationString: path ];
          at: 'codeSubdirectory' ifPresent: [:path | IceRepository defaultCodeSubdirectory: path ] ] ]
      runOnce: true).

    (StartupAction
      name: 'Debugger options'
      code: [ Smalltalk tools debugger alwaysOpenFullDebugger: true ]
      runOnce: true).

    (StartupAction
      name: 'Code formatting options BA-ST guidelines'
      code: [
        BIConfigurableFormatter
          maxLineLength: 100;
          useBasicCommentFormat: true;
          formatCommentWithStatements: true;
          indentString: Character tab asString;
          "Signature"
          methodSignatureOnMultipleLines: true;
          selectorAndArgumentCombinedMaxSize: 40;
          "Blocks"
          keepBlockInMessage: true;
          lineUpBlockBrackets: true;
          "Keywords"
          oneLineMessages: '#(#to: #to:do: #to:by: #to:by:do:)';
          multiLineMessages: '#(#ifTrue:ifFalse: #ifFalse:ifTrue: #ifTrue: #ifFalse: #on:do: #ensure: #ifCurtailed:)';
          newLineBeforeFirstKeyword: false;
          indentsForKeywords: 1;
          "Line Breaks"
          newLinesAfterMethodComment: 2;
          newLinesAfterMethodPattern: 2;
          newLinesAfterTemporaries: 2;
          minimumNewLinesBetweenStatements: 1;
          retainBlankLinesBetweenStatements: true;
          retainBlankLinesBeforeComments: false;
          "General"
          periodsAtEndOfBlock: false;
          periodsAtEndOfMethod: false;
          stringFollowingReturn: Character space asString;
          stringInsideBlocks: Character space asString;
          stringInsideParentheses: Character space asString;
          "Parentheses"
          useTraditionalBinaryPrecedenceForParentheses: true;
          traditionalBinaryPrecedenceArray: '#(#($| $& $?) #($= $~ $< $>) #($- $+) #($* $/ $% $\) #($@))';
          "Cascades"
          newLineAfterCascade: true;
          newLineBeforeFirstCascade: true.
        ]
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
      name: 'Disable Utility Methods Rule'
      code: [ (RBAddMethodChange compile: 'basicCheck: aMethod<r><t>^ false' expandMacros in: RBUtilityMethodsRule) execute ]
      runOnce: true).

    (StartupAction
      name: 'Configure Iceberg'
      code: [
        Iceberg enableMetacelloIntegration: true.
        userProperties at: #iceberg ifPresent: [:config | | iceberg |
          iceberg := SystemVersion current major < 7 ifTrue: [IceRepository] ifFalse: [IceLibgitRepository].
          iceberg reset.
          config
            at: #shared_directory ifPresent: [:directory |
              iceberg
                shareRepositoriesBetweenImages: true;
                sharedRepositoriesLocationString: directory];
            at: #code_subdirectory ifPresent: [:directory | iceberg defaultCodeSubdirectory: directory ] ] ]
      runOnce: true).

    (StartupAction
      name: 'Configure Playground'
      code: [
        userProperties at: #playground ifPresent: [:playground |
          playground at: #stash_directory ifPresent: [:directory | GTPlayBook stashDirectory: directory ] ] ]
      runOnce: true).

    (StartupAction
      name: 'Show any startup action errors'
      code: [ StartupPreferencesLoader default errors ifNotEmpty: [ :errors | errors explore ] ]
      runOnce: true).
  }
] value.
