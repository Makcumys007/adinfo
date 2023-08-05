Import-module ActiveDirectory

Write-Host "-==*** Утилита ADInfo v0.1.12 05/08/2023 ***==-" -ForegroundColor Green
Write-Host "Для справки введите help или -h" -ForegroundColor Yellow
Write-Host "Для выхода введите exit или -e" -ForegroundColor Yellow

while($true) {
    $input = Read-Host "ADInfo"
    $input = $input.Trim()
    if($input -eq "exit" -or $input -eq "-e") {
        break
    }

    try {
        
        if($input -eq "help" -or $input -eq "-h") {

            Write-Host "-==*** Утилита ADInfo v0.1.12 05/08/2023 ***==-" -ForegroundColor Green

            Write-Host "Для получения справки об УЗ пользователя
            введите login login: maxim.abylkassov
            введите name name: maxim
            введите nameLastname name lastname: maxim abylkassov
            введите lastname lastname: abylkassov
            введите email email: maxim.abylkassov@kazminerals.com"

            Write-Host "Для получения списка всех групп пользователя
            введите login -GetGroups: maxim.abylkassov -GetGroups"

            Write-Host "Для изменения пароля УЗ пользователя
            введите login -NewPassword: maxim.abylkassov -NewPassword"

            Write-Host "Для продления пароля УЗ пользователя
            введите login -PwdExtension: maxim.abylkassov -PwdExtension"

            Write-Host "Для изменения телевона в УЗ пользователя 
            введите login -SetPhone number: maxim.abylkassov -SetPhone 50393"

            Write-Host "Для получениясправки
            введите -help или -h"

            Write-Host "Для выхода из утелиты
            введите exit или -e"

            Write-Host "Разработчик Maxim.Abylkassov" -ForegroundColor Green

        } elseif ($input -like "email*") {
            $parameters = $input.split(" ") 
            $email = $parameters[1]
            Get-ADUser -Filter {UserPrincipalName -like $email} -Properties otherTelephone, telephoneNumber, employeeID
        
        } elseif ($input -like "nameLastname*") { 
            $parameters = $input.split(" ") 
            $cn = $parameters[1] + " " + $parameters[2]
            Get-ADUser -Filter {cn -like $cn} -Properties otherTelephone, telephoneNumber, employeeID
        
        }
        elseif ($input -like "login*") {
            $parameters = $input.split(" ") 
            $login = $parameters[1]
            
            Get-ADUser -Filter {mailNickname -like $login} -Properties otherTelephone, telephoneNumber, employeeID       
        }
        elseif ($input -like "lastname*") {
            $parameters = $input.split(" ") 
            $sn = $parameters[1]                 
            
            Get-ADUser -Filter {sn -like $sn} -Properties otherTelephone, telephoneNumber, employeeID
        }
        elseif ($input -like "name*") {
            $parameters = $input.split(" ") 
            $givenName = $parameters[1]                 
            Get-ADUser -Filter {givenName -like $givenName} -Properties otherTelephone, telephoneNumber, employeeID
        
        } 

        # Change Password

        elseif ($input -like "*-NewPassword") {
            
            $user = $input.split(" ")[0]
            

            $SecurePassword = Read-Host -Prompt "Введите новый пароль" -AsSecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
            $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

            Set-ADAccountPassword $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $UnsecurePassword -Force -Verbose) –PassThru

            Write-Host "Пароль был успешно изменен" -ForegroundColor Green
        }

        # Extension Password

        elseif ($input -like "*-PwdExtension") {
            
            $user = $input.split(" ")[0]
            
            Set-ADUser $user -Replace @{pwdLastSet='0'}
            Set-ADUser $user -Replace @{pwdLastSet='-1'}        
             
            Write-Host "Пароль был успешно продлен" -ForegroundColor Green
        }

        # Set PhoneNumbera-a

        elseif ($input -like "*-SetPhone*") {
            
            $parameters = $input.split(" ")   

            $user = $parameters[0]
            
            if ($parameters.Count -ge 3) { 
                $newPhone = $parameters[2]                             
                Set-ADUser $user -Clear "telephoneNumber"
                Set-ADUser $user -Add @{telephoneNumber = $newPhone}
                Write-Host "Телефон был успешно обновлен" -ForegroundColor Green
            } 
        }

        elseif ($input -like "*-GetGroups") {
            $parameters = $input.split(" ")   

            $user = $parameters[0]

            Get-ADPrincipalGroupMembership $user | select name

        }

        else {
            
            Write-Host "Что то пошло не так, попробуйте еще раз или введите exit для выхода..." -ForegroundColor Red
        }
              

    } catch {
        Write-Host "Что то пошло не так, попробуйте еще раз или введите exit для выхода..." -ForegroundColor Red
    }

}
