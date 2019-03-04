# runa-test
Test repo
Requerimientos funcionales:
- Inicio de sesión de administrador de la empresa
- Inicio de sesión de empleado
- El administrador marque la entrada y salida de sus empleados
- El administrador gestione los reportes de entrada y salida de sus empleados
- El administrador gestione la información de empleados
- El empleado revise su reporte de entrada y salida

Consideraciones:
- Backend en Ruby on Rails v5.1.3 y debe existir un cliente frontend que pueda consumir el API (puede estar hecho con vistas de Rails pero debe consumir el API como si fuera una aplicación por separado)
- API debe estar documentado
- Usar PostgreSQL
- Aplicar Unit testing o testing funcional
- El criterio del postulante será el punto más importante a evaluar.
##Testing Online: 
###authentication:

    curl -H "Content-Type: application/json" -X POST -d "{\"email\":\"example@mail.com\",\"password\":\"123123123\"}" http://localhost:3000/authenticate

Se puede probar el sistema en la url:

https://runa-test.herokuapp.com/

usuario:example@mail.com
password:123123123

