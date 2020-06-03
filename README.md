# DiffReport

A description of this package.

## Create file
xcrun xccov view --report --json develop.xcresult | python -m json.tool | jq --raw-output '[ .targets[] | { name, lineCoverage } ]' > base.json
xcrun xccov view --report --json new.xcresult | python -m json.tool | jq --raw-output '[ .targets[] | { name, lineCoverage } ]' > new.json

git clone https://github.com/mackoj/DiffReport.git
cd DiffReport
swift run cli base.json new.json output.json

## Exemple de sortie

| Target | PreviousValue | NewValue | Diff |
| --- | --- | --- | --- |
| Alamofire | 0.0 | 0.0 | = |
| CacheManager | 0.0 | 0.0 | = |
| CasePaths | 0.43209876543209874 | 0.43209876543209874 | = |
| ComposableArchitecture | 0.18530225207427894 | 0.18688265507704466 | BetterThanBefore |
| ComposableCoreLocation | 0.45045045045045046 | 0.45045045045045046 | = |
| Logger | 0.7906976744186046 | 0.7906976744186046 | = |
| PagesJaunes.app | 0.510743219443466 | 0.49719276356830944 | WorseThanBefore |
| Result | 0.0 | 0.0 | = |
| SnapshotTesting | 0.0 | 0.0 | = |
| StargateKitCore | 0.008561643835616438 | 0.008561643835616438 | = |
| StargateKitRequest | 0.02583068477318694 | 0.02583068477318694 | = |
| UnitTests.xctest | 0.9702517162471396 | 0.9758364312267658 | BetterThanBefore |
