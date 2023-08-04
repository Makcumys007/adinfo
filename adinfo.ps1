Import-module ActiveDirectory

while($true) {
    $input = Read-Host "Пожалуйста, введите email/login"
    $input = $input.Trim()
    if($input -eq "exit" -or $input -eq "-e") {
        break
    }

    try {
        if ($input -like "*@kazminerals.com") {
            $email = $input
            Get-ADUser -Filter {UserPrincipalName -like $email} -Properties otherTelephone, telephoneNumber, employeeID
        } elseif ($input -like "* *") { 
            $cn = $input
            Get-ADUser -Filter {cn -like $cn} -Properties otherTelephone, telephoneNumber, employeeID
        }
        else {
            $login = $input
            Get-ADUser -Filter {mailNickname -like $login} -Properties otherTelephone, telephoneNumber, employeeID        
            Get-ADUser -Filter {sn -like $login} -Properties otherTelephone, telephoneNumber, employeeID
        }

        # Change Password

        if ($input -like "*-NewPassword") {
            
            $user = $input.split(" ")[0]
            

            $SecurePassword = Read-Host -Prompt "Введите новый пароль" -AsSecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
            $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

            Set-ADAccountPassword $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $UnsecurePassword -Force -Verbose) –PassThru

            Write-Host "Пароль был успешно изменен"
        }

        # Extension Password

        if ($input -like "*-PwdExtension") {
            
            $user = $input.split(" ")[0]
            
            Set-ADUser $user -Replace @{pwdLastSet='0'}
            Set-ADUser $user -Replace @{pwdLastSet='-1'}        

            Write-Host "Пароль был успешно продлен"
        }

        # Set PhoneNumbera-a

        if ($input -like "*-SetPhone*") {
            
            $parameters = $input.split(" ")   

            $user = $parameters[0]
            
            if ($parameters.Count -ge 3) { 
                $newPhone = $parameters[2]                             
                Set-ADUser $user -Clear "telephoneNumber"
                Set-ADUser $user -Add @{telephoneNumber = $newPhone}
                Write-Host "Телефон был успешно обновлен"
            } 
        }
        

    } catch {
        Write-Host "Что то пошло не так, попробуйте еще раз или введите exit для выхода..."
    }

    


    if($input -eq "-help" -or $input -eq "-h") {
        Write-Host "-==*** Утилита ADInfo v0.1.10 04/08/2023 ***==-"
        Write-Host "Для получения справки об УЗ пользователя
        введить login: maxim.abylkassov
        введите lastname: abylkassov
        введите email: maxim.abylkassov@kazminerals.com"
        Write-Host "Для изменения пароля УЗ пользователя
        введите login -NewPassword: maxim.abylkassov -NewPassword"
        Write-Host "Для продления пароля УЗ пользователя
        введите login -PwdExtension: maxim.abylkassov -PwdExtension"
        Write-Host "Для изменения телевона в УЗ пользователя 
        введите login -SetPhone number: maxim.abylkassov -SetPhone 50393"
    }
    

}
