# ===================================================================
# 依存DLLのロード
# ===================================================================
$dllPaths = @(
    Join-Path $PSScriptRoot "bin\SqlKata.dll"
)

ForEach($dllPath in $dllPaths)
{
    Add-Type -Path $dllPath
}


# ===================================================================
# モジュールの実装
# ===================================================================

function New-SqlKataQuery
{
    <#
    .SYNOPSIS
        Creates a empty SqlKata Query instance.

    .DESCRIPTION
        The New-SqlKataQuery cmdlet initializes and returns a blank instance of the
        SqlKata.Query object. This allows you to dynamically build SQL queries from scratch.

    .INPUTS
        None.

    .OUTPUTS
        SqlKata.Query. This cmdlet returns an empty SqlKata Query object.

    .EXAMPLE
        # Create a blank query and define the FROM clause manually (e.g., for DuckDB functions)
        $Query = New-SqlKataQuery
        $Query.FromRaw("generate_series(1, 100) AS t(i)").Select("i")
    #>
    [CmdletBinding()]
    [OutputType([SqlKata.Query])]
    Param()

    Process
    {
        New-Object SqlKata.Query -ArgumentList @($TableName)
    }
}

function ConvertFrom-SqlKataQuery
{
    <#
    .SYNOPSIS
        Compiles a SqlKata Query object into a raw SQL string.

    .DESCRIPTION
        The ConvertFrom-SqlKataQuery cmdlet takes a SqlKata.Query object and uses the
        PostgresCompiler to generate a standard PostgreSQL/DuckDB compatible SQL string.

    .PARAMETER InputObject
        The SqlKata.Query object to be compiled into a SQL statement.
        This parameter accepts input from the pipeline.

    .INPUTS
        SqlKata.Query. You can pipe a Query object into this cmdlet.

    .OUTPUTS
        System.String. Returns the compiled SQL statement as a raw text string.

    .EXAMPLE
        $Query = New-SqlKataQuery
        $Query.FromRaw("generate_series(1, 100) AS t(i)").Select("i")
        $SqlText = $Query | ConvertFrom-SqlKataQuery -InputObject $Query
    #>
    [CmdletBinding()]
    [OutputType([string])]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [SqlKata.Query]$InputObject
    )

    Process
    {
        $compiler = New-Object SqlKata.Compilers.PostgresCompiler
        $compilerResult = $compiler.Compile($InputObject)
        $sqlText = $compilerResult.Sql
        $sqlText
    }

}

Export-ModuleMember -Function @("New-SqlKataQuery", "ConvertFrom-SqlKataQuery")
