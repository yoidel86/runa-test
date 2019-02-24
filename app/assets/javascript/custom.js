var dialog_form = `<div id="dialog-form" title="Crear nuevo usuario">
                  <p class="validateTips">Todos son requeridos.</p>
                  <form>
                    <fieldset>
                      <label for="name">Name</label>
                      <input type="text" name="name" id="name" class="form-control">
                      <label for="email">Email</label>
                      <input type="text" name="email" id="email"  class="form-control">
                      <label for="password">Password</label>
                      <input type="password" name="password" id="password"  class="form-control">
                      <label for="password_confirmation">Confirmar Password</label>
                      <input type="password" name="password_confirmation" id="password_confirmation"  class="form-control">
                      <!-- Allow form submission with keyboard without duplicating the dialog button -->
                      <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                    </fieldset>
                  </form>
                </div>`;

function loadIndex(load_to) {
    $.ajax({
        url: routes["index"],
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (content) {
            $(load_to).html(content);
            // $("#load_users").click(loadUsers);
        }
    });
}
//users manager
function loadUsers(){
    $.ajax({
        url: routes["users"],
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (content) {
            $("li.active").removeClass("active");
            $("#load_users").parent().addClass("active");
            $(".subtitle").html("USUARIOS");
            var table_content = ``;
            $.each(content.users,function(i,val){
                table_content += `<tr><td>${val.name}</td><td>${val.email}</td>
                    <td><a href="#delete" class="remove" data-id="${val.id}">X</a></td>
                    </tr>`;
            });
            var userTable = `
                <table class="table">
                <thead><th>Nombre</th><th>Correo</th><th>Acciones</th></thead>
                <tbody id="users_body">${table_content}</tbody>
                </table>
                <br>
                <div class="btn btn-info" id="add_user"> Crear Usuario </div>
                ${dialog_form}
            `;

            $(".dashboard_content").html(userTable);
            var dialog = $( "#dialog-form" ).dialog({
                autoOpen: false,
                height: 400,
                width: 350,
                modal: true,
                buttons:
                    [
                        {
                            text: "Submit",
                            "class": 'btn btn-info',
                            click: function() {
                                addUser();
                                $(this).dialog("close");
                            }
                        },
                        {
                            text: "Cancel",
                            "class": 'btn btn-default',
                            click: function() {
                                $(this).dialog("close");
                            }
                        }
                    ]
            });

            $("#add_user").click(function(){
                dialog.dialog( "open" );
            })

        }
    });
}

function addUser(){
    var name = $("#name").val();
    var email = $("#email").val();
    var password = $("#password").val();
    var password_confirm = $("#password_confirm").val();
    $.ajax({
        url: routes["create"],
        data:{name:name,email:email,password:password,password_confirm:password_confirm},
        type: "POST",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (val) {
            $("#users_body").append(`<tr><td>${val.name}</td><td>${val.email}</td>
                    <td><a href="#delete" class="remove" data-id="${val.id}">X</a></td>
                    </tr>`);
            console.log(content);
        }}
    );
}
//dashboard view
function loadCharts(){
    console.log("ESTO NO SE LLAMA NUNCA");

    $('#chart1').easyPieChart({
        size:180,
        barColor:'#3ba0ff',
        lineWidth:5,
    });

    $('#chart2').easyPieChart({
        size:180,
        barColor:'#57BE85',
        lineWidth:5,
    });

    $('#chart3').easyPieChart({
        size:180,
        barColor:'#ff6c60',
        lineWidth:5,
    });

    window.chart = c3.generate({
        bindto: '#spline-chart',
        data: {
            columns: [
                ['Speed', 210, 170, 145, 200, 220, 210],
                ['Time', 130, 100, 130, 180, 150, 50],
                ['Visitors', 80, 110, 70, 150, 110, 140],
            ],
            types: {
                Speed: 'area-spline',
                Time: 'spline',
                Visitors:'area-spline'
            }
        },
        color: {
            pattern: ['#57BE85','#ff6c60','#3ba0ff']
        },
        size: {
            height: 300
        },
    });
}
//login-logout view
function loadLoginLogoutView(){
    $(".subtitle").html("Registro de Entrada y Salida");
    $("li.active").removeClass("active");
    $("#entrada_salida").parent().addClass("active");
    $(".dashboard_content").html(`
        <div class="row">
            <div class="col-md-12">
            <h4>Usuarios que no han entrado</h4>
                <div id="not_logged_users"></div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
             <h4>Usuarios que no han salido</h4>
                <div id="logged_in_users"></div>
            </div>
        </div>
       
        <div class="row">
            <div class="col-md-12">
            <h4>Usuarios que ya entraron y salieron</h4>
                 <div id="full_logged_users"></div>
            </div>
        </div>
    `);
    loadLoggedInUsers();
    loadNotLoggedDayUsers();
    loadFullLoggedDayUsers();
}

function loadLoggedInUsers(){
    $.ajax({
        url: routes["loggedUsers"],
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (content) {
            console.log(content);
            var table_content = ``;
            $.each(content.users,function(i,val){
                table_content += `<tr><td>${val.name}</td><td>${val.email}</td><td>${val.time_in}</td>
                    <td><a href="#userregister" class="logout_user" data-id="${val.id}" data-user="${val.user_id}">Salida</a></td>
                    </tr>`;
            });
            var userTable = `
                <table class="table">
                <thead><th>Nombre</th><th>Correo</th><th>Hora entrada</th><th>Registrar</th></thead>
                <tbody id="users_body">${table_content}</tbody>
                </table>
                <br>
                             
            `;

            $("#logged_in_users").html(userTable);
            $(".logout_user").click( function(){
                loggoutUser($(this).data("id"),$(this).data("user"));
            });
        }
    });
}

function loadNotLoggedDayUsers(){
    $.ajax({
        url: routes["notLoggedUsers"],
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (content) {
            console.log(content);
            var table_content = ``;
            $.each(content.users,function(i,val){
                table_content += `<tr><td>${val.name}</td><td>${val.email}</td>
                    <td><a href="#userregister" class="login_user" data-id="${val.id}">Entrada</a></td>
                    </tr>`;
            });
            var userTable = `
                <table class="table">
                <thead><th>Nombre</th><th>Correo</th><th>Registrar</th></thead>
                <tbody id="users_body">${table_content}</tbody>
                </table>
                <br>
            `;

            $("#not_logged_users").html(userTable);
            $(".login_user").click(function(s){
                console.log($(this).data("id"));
                logginUser($(this).data("id"));
            })
        }
    });
}

function loadFullLoggedDayUsers(){
    $.ajax({
        url: routes["dayLoggedUsers"],
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (content) {
            var table_content = ``;
            $.each(content.users,function(i,val){
                table_content += `<tr><td>${val.name}</td><td>${val.email}</td>
                    <td>${val.time_in}</td>
                    <td>${val.time_out}</td>
                    </tr>`;
            });
            var userTable = `
                <table class="table">
                <thead><th>Nombre</th><th>Correo</th><th>Hora Entrada</th><th>Hora Salida</th></thead>
                <tbody id="users_body">${table_content}</tbody>
                </table>
                <br>          
            `;

            $("#full_logged_users").html(userTable);

        }
    });
}

function logginUser(id){
    $.ajax({
        url: routes["api_login"]+id,
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (content) {
            loadLoginLogoutView();
        }
    });
}

function loggoutUser(id,userid){
    $.ajax({
        url: routes["api_logout"]+`${userid}/${id}`,
        type: "GET",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Authorization", sessionStorage.getItem("auth_token"))
        },
        success: function (content) {
            loadLoginLogoutView();
        }
    });
}

