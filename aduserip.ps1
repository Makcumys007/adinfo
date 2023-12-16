

# Подключаем модуль Active Directory
Import-Module ActiveDirectory





Write-Host "-==*** Утилита ADUserIP v0.1.12 16/12/2023 ***==-" -ForegroundColor Green
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


            Write-Host "Для получения IP и HOSTNAME
            введите: lastuser "

           

            Write-Host "Для выхода из утелиты
            введите exit или -e"

            Write-Host "Разработчик Maxim.Abylkassov" -ForegroundColor Green

        } elseif ($input -like "lastuser*") {
            $parameters = $input.split(" ") 
            $user = $parameters[1] + ' ' + $parameters[2]
            Write-Host $user -ForegroundColor Yellow
            $user = "$user*"
            # Ищем компьютер по description
                $computers = Get-ADComputer -Filter {description -like $user} -Properties IPv4Address, LastLogonDate, OperatingSystem, extensionAttribute3, extensionAttribute1

                # Выводим значение атрибута extensionAttribute5 для каждого компьютера
                foreach ($computer in $computers) {
                    Write-Host "Computer Name: $($computer.Name)"
                    Write-Host "IPv4Address: $($computer.IPv4Address)"
                    Write-Host "OperatingSystem : $($computer.OperatingSystem)"
                    Write-Host "Model of device: $($computer.extensionAttribute3)"
                    Write-Host "Last User: $($computer.extensionAttribute1)"
                    Write-Host "LastLogonDate: $($computer.LastLogonDate)"
                    Write-Host "------------------------"
                }
        
        } 

        else {
            
            Write-Host "Что то пошло не так, попробуйте еще раз или введите exit для выхода..." -ForegroundColor Red
        }
              

    } catch {
        Write-Host "Что то пошло не так, попробуйте еще раз или введите exit для выхода..." -ForegroundColor Red
    }

}
