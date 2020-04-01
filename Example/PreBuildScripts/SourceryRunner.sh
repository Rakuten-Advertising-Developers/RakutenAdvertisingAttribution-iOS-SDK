echo "======>>>> Start Sourcery Runner"

srcroot=$1

sourcesPath=$srcroot/betmoApp/betmoApp/app/
outputPath=$srcroot/betmoApp/betmoApp/app/Models/SourceryGenerated
templatesPath=$srcroot/SourceryTemplates
$srcroot/Pods/Sourcery/bin/sourcery --sources $sourcesPath --templates $templatesPath --output $outputPath


echo "======<<<<< End Sourcery Runner"