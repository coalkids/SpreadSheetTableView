/*
 * Jakefile
 *
 * Copyright (C) 2010  Alexandre Wilhelm, Christophe Serafin and Julien Seiler
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */


var ENV = require("system").env,
    FILE = require("file"),
	OS = require("os"),
	JAKE = require("jake"),
    task = JAKE.task,
    CLEAN = require("jake/clean").CLEAN,
    FileList = JAKE.FileList,
    framework = require("cappuccino/jake").framework,
    configuration = ENV["CONFIGURATION"] || "Release";

framework ("SpreadSheetTableView", function(task)
{
    task.setBuildIntermediatesPath(FILE.join("Build", "SpreadSheetTableView.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("SpreadSheetTableView");
    task.setIdentifier("fr.bulleval.SpreadSheetTableView");
    task.setVersion("0.1");
    task.setAuthor("Alexandre Wilhelm");
    task.setEmail("alexandre.wilhelmfr@gmail.com");
    task.setSummary("SpreadSheetTableView for CPTableView");
    task.setSources(new FileList("*.j", "SpreadSheetTableView/*.j", "Categories/*.j"));
    task.setResources(new FileList("Resources/*"));
    task.setInfoPlistPath("Info.plist");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

task("build", ["SpreadSheetTableView"]);

task("debug", function()
{
    ENV["CONFIGURATION"] = "Debug"
    JAKE.subjake(["."], "build", ENV);
});

task("release", function()
{
    ENV["CONFIGURATION"] = "Release"
    JAKE.subjake(["."], "build", ENV);
});

task ("documentation", function()
{
   OS.system("doxygen REST.doxygen")
});

task("test", function()
{
    var tests = new FileList('Test/*Test.j');
    var cmd = ["ojtest"].concat(tests.items());
    var cmdString = cmd.map(OS.enquote).join(" ");

    var code = OS.system(cmdString);
    if (code !== 0)
        OS.exit(code);
});

task ("default", ["release"]);
task ("docs", ["documentation"]);
task ("all", ["release", "debug", "documentation"]);