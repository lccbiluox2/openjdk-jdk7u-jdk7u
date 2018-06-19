#!/bin/sh

#
# Copyright (c) 2011, Oracle and/or its affiliates. All rights reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
#
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
# or visit www.oracle.com if you need additional information or have any
# questions.
#


# @test
# @bug 7104647
# @summary Unit test for jcmd utility
#
# @library ../common
# @build SimpleApplication ShutdownSimpleApplication
# @run shell jcmd-pid.sh

. ${TESTSRC}/../common/CommonSetup.sh
. ${TESTSRC}/../common/ApplicationSetup.sh

# Start application and use PORTFILE for coordination
PORTFILE="${TESTCLASSES}"/shutdown.port
startApplication SimpleApplication "${PORTFILE}"

# all return statuses are checked in this test
set +e

failed=0

# help command 
${JCMD} -J-XX:+UsePerfData $appJavaPid help 2>&1 | awk -f ${TESTSRC}/jcmd_pid_Output1.awk
if [ $? != 0 ]; then failed=1; fi

# PerfCounter.list option
${JCMD} -J-XX:+UsePerfData $appJavaPid PerfCounter.print 2>&1 | awk -f ${TESTSRC}/jcmd_pid_Output2.awk
if [ $? != 0 ]; then failed=1; fi

set -e

stopApplication "${PORTFILE}"
waitForApplication

exit $failed
