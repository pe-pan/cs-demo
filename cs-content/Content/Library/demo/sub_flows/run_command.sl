#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#

########################################################################################################################
#!!
#! @description: Runs a shell command locally.
#!
#! @input command: Command to run.
#! @input cwd: Current working directory.
#!            If cwd is not None, the child’s current directory will be changed to cwd before it is executed.
#!            Note that this directory is not considered when searching the executable,
#!            so you can’t specify the program’s path relative to cwd.
#!
#! @output return_result: Output of the command.
#! @output error_message: error in case something went wrong.
#! @output return_code: 0 if command runs with success, -1 in case of failure.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

#Copied from https://github.com/CloudSlang/cs-content/blob/master/content/io/cloudslang/base/cmd/run_command.sl

namespace: io.cloudslang.demo.sub_flows

operation:
  name: run_command

  inputs:
    - command
    - cwd:
        required: false
        default: null

  python_action:
    script: |
      import os
      import subprocess
      return_code = 0
      return_result = ''
      error_message = ''
      cwd = os.getcwd() if cwd is None else cwd
      try:
        res = subprocess.Popen(command,cwd=cwd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True);
        output,error = res.communicate()
        if output:
          return_result = output
          return_code = res.returncode
        if error:
          return_code = res.returncode
          error_message = error.strip()
      except Exception as e:
        return_code = -1
        error_message = e

  outputs:
    - return_result
    - return_code: ${ str(return_code) }
    - error_message

  results:
    - SUCCESS: ${return_code == 0}
    - FAILURE