# PSSqlKata

A simple PowerShell wrapper for [SqlKata](https://github.com/sqlkata/querybuilder).

PSSqlKata provides a small PowerShell interface for creating and compiling `SqlKata.Query` objects.

## Requirements

### Runtime

* PowerShell 5.1 or later

No .NET SDK installation is required to use the module.

### Development

The following is required to build the module:

* .NET SDK
* PowerShell 5.1 or later

## Installation

### From source

If you are building the module from this repository:

```powershell
git clone https://github.com/pomu0326/PSSqlKata.git
cd PSSqlKata

.\build.ps1
```

The build script downloads the required `SqlKata` dependency into `src\bin`.

Then import the module:

```powershell
Import-Module .\src\pomu0326.PSSqlKata.psd1
```

## Usage

### Create a query

`New-SqlKataQuery` creates an empty `SqlKata.Query` object.

```powershell
$query = New-SqlKataQuery

$query.From("users").
    Select("id", "name").
    Where("active", 1)
```

Since the returned object is a native `SqlKata.Query` instance, SqlKata's query-building API can be used directly.

### Compile a query

`ConvertFrom-SqlKataQuery` compiles a `SqlKata.Query` into a SQL string.

```powershell
$query = New-SqlKataQuery

$query.From("users").
    Select("id", "name").
    Where("active", 1)

$sql = $query | ConvertFrom-SqlKataQuery

$sql
```

The query is compiled using `SqlKata.Compilers.PostgresCompiler`.

## Cmdlets

### `New-SqlKataQuery`

Creates an empty `SqlKata.Query` instance.

### `ConvertFrom-SqlKataQuery`

Compiles a `SqlKata.Query` object into a SQL string.

The cmdlet accepts `SqlKata.Query` objects through the pipeline.

## Build

The project does not contain C# implementation code. The `.csproj` file is used to restore the `SqlKata` NuGet package and obtain the required DLL.

Run:

```powershell
.\build.ps1
```

The required dependency is copied to:

```text
src\bin\SqlKata.dll
```

## Dependencies

PSSqlKata uses [SqlKata](https://github.com/sqlkata/querybuilder).

* SqlKata 2.4.0
* License: MIT

See [LICENSE_THIRDPARTY](LICENSE_THIRDPARTY) for the third-party license.

## License

PSSqlKata is licensed under the MIT License.

See [LICENSE](LICENSE) for details.

