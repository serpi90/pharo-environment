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
			name: 'Setup fonts'
			code: [ userProperties at: #fonts ifPresent: [ :fonts | 
						fonts at: #default ifPresent: [ :font | 
								StandardFonts defaultFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) forceNotBold.
								GraphicFontSettings resetAllFontToDefault.
								"It does weird things if we leave windowTitleFont bold but with same familyName and size so we use size + 1"
								StandardFonts windowTitleFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size) + 1) forceBold ].
						fonts at: #code ifPresent: [ :font | StandardFonts codeFont: (LogicalFont familyName: (font at: #name) pointSize: (font at: #size)) ] ] ]
			runOnce: true).

		(StartupAction
			name: 'Set up UI theme'
			code: [ userProperties at: #theme ifPresent: [ :theme | Smalltalk at: theme asSymbol ifPresent: [ :themeClass | themeClass beCurrent ] ] ]
			runOnce: true).

		(StartupAction
			name: 'Set up syntax highlighting style'
			code: [ userProperties at: #sytaxTheme ifPresent: [ :theme | SHPreferences setStyleTableNamed: theme ] ]
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
			name: 'Disable Utility Methods Rule'
			code: [ (RBAddMethodChange compile: 'basicCheck: aMethod<r><t>^ false' expandMacros in: RBUtilityMethodsRule) execute ]
			runOnce: true).

		(StartupAction
			name: 'Enable Iceberg Metacello integration'
			code: [ Iceberg enableMetacelloIntegration: true ]
			runOnce: true).

		(StartupAction
			name: 'Set iceberg shared repository'
			code: [ IceRepository shareRepositoriesBetweenImages: true.
			IceRepository sharedRepositoriesLocationString: ((userProperties at: #iceberg) at: #shared_directory) ]
			runOnce: true).

		(StartupAction
			name: 'Set Iceberg default code subdirectory'
			code: [ IceRepository defaultCodeSubdirectory: ((userProperties at: #iceberg) at: #code_subdirectory) ]
			runOnce: true).

		(StartupAction
			name: 'Local Playground stash directory'
			code: [ GTPlayBook stashDirectory: ((StartupContext at: #playground) at: #stash_directory) ]
			runOnce: true).

		(StartupAction
			name: 'Show any startup action errors'
			code: [ StartupPreferencesLoader default errors ifNotEmpty: [ :errors | errors explore ] ]
			runOnce: true).

}
] value
