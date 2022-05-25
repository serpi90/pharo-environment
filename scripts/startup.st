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
          StandardFonts 
            defaultFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) 
            forceNotBold.
          GraphicFontSettings resetAllFontToDefault.
          "It does weird things if we leave windowTitleFont bold but with same familyName and size so we use size + 1"
          StandardFonts 
            windowTitleFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size) + 1) 
            forceBold ].
        fonts at: #code ifPresent: [ :font | 
          StandardFonts 
            codeFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) ] ] ]).

    (StartupAction
      name: 'Set up UI theme'
      code: [ userProperties at: #theme ifPresent: [ :theme | Smalltalk at: theme asSymbol ifPresent: [ :themeClass | themeClass beCurrent ] ] ]
      runOnce: true).

    (StartupAction
      name: 'Code formatting options'
      code: [ 
             | codeFormatting |

             codeFormatting := (ZnEasy get: 'https://gist.githubusercontent.com/gcotelli/08730091ba8a4fe0e557aeca489ebde8/raw/2b4deaf05928eec1af129537390b52dfacb6ea2d/CodeFormatting.st') contents.

                                Smalltalk compiler class new source: codeFormatting; evaluate. ] 
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
          iceberg := IceLibgitRepository.
          iceberg reset.
          config
            at: #shared_directory ifPresent: [:directory |
              iceberg
                shareRepositoriesBetweenImages: true;
                sharedRepositoriesLocationString: directory];
            at: #code_subdirectory ifPresent: [:directory | 
              iceberg defaultCodeSubdirectory: directory ] ] ]
      runOnce: true).

    (StartupAction
      name: 'Configure Playground'
      code: [
        userProperties at: #playground ifPresent: [:playground |
          playground at: #stash_directory ifPresent: [:directory | 
            GTPlayBook stashDirectory: directory ] ] ]
      runOnce: true).

    (StartupAction
      name: 'Show any startup action errors'
      code: [ StartupPreferencesLoader default errors ifNotEmpty: [ :errors | errors explore ] ]
      runOnce: true).
  }
] value.
