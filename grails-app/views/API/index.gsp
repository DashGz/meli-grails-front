<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

    <meta name="layout" content="main"/>
    <title>IT Academy</title>
    <script src="https://unpkg.com/vue/dist/vue.min.js"></script>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

</head>
<body>



    <div id="seleccion" class="container mt-4" >
        <div class="row" id="path" hidden></div>
         <div>
            <select id="select" v-model="selected" class="form-control">
                <g:each in="${sites}" var="site">
                    <option value="${site?.id}">${site?.name}</option>
                </g:each>
            </select> <br/>


                    <span v-for="category in categories">
                        <a href="#" @click="getSubCat(category.id)">{{ category.name  }}</a> <br/>
                    </span>


         </div>

            <div id="btnAdd" class="btn" hidden>
                <button type="button" class="btn btn-primary" @click="addArticulo()">Add Article</button>
            </div>

    <div id="myModal" class="modal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Articulo</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>ID: {{ id }}</p><br/>
                    <p>NAME: {{ name }}</p><br/>
                    <p>PICTURE:<img id="imgLI" class="img-fluid"> <img/></p><br/>
                    <p>ITEMS: {{ totalItems }}</p><br/>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" @click="showEdit()">Edit</button>
                    <button type="button" class="btn btn-danger" @click="deleteArticulo()">Delete</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
                <div id="divEdit" hidden class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="editName">Name</label>
                            <input class="form-control" id="editName" placeholder="Enter article name">
                        </div>
                        <div class="form-group">
                            <label for="editPicture">Picture</label>
                            <input class="form-control" id="editPicture" placeholder="Enter picture link">
                        </div>
                        <button type="submit" class="btn btn-primary" @click="editArticulo()" data-dismiss="modal">Submit</button>
                    </form>
                </div>
            </div>
        </div>
    </div>


        <div id="modal2" class="modal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add Article</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div id="divAdd" class="modal-body">
                        <form>
                            <div class="form-group">
                                <label for="addName">Name</label>
                                <input class="form-control" id="addName" placeholder="Enter article name">
                            </div>
                            <div class="form-group">
                                <label for="addPicture">Picture</label>
                                <input class="form-control" id="addPicture" placeholder="Enter picture link">
                            </div>
                            <button type="submit" class="btn btn-primary" @click="saveArticulo()" data-dismiss="modal">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>




    </div>



    <script>
        var seleccion = new Vue({
            el: '#seleccion',
            data: {
                selected: "",
                categories: [],
                id: "",
                name: "",
                picture: "",
                totalItems: "",
                primerPath: "",
                //statusCode: ""
            },
            watch: {
                'selected': function () {
                    document.getElementById('btnAdd').hidden = false;

                    axios.get('/API/categories', {
                        params: {
                            selected: this.selected
                        }
                    }).then(function (response) {
                        select = this.document.getElementById("select");
                        idSelect = select.value;
                        nombre = select.options[select.selectedIndex].innerHTML;
                        document.getElementById("path").innerHTML = "";
                        document.getElementById("path").innerHTML = "<a href='#' onclick=seleccion.crearPath('"+ idSelect +"')>"+nombre+"</a>";
                        seleccion.categories = response.data.categories;

                        primerPath = "<a href='#' onclick=seleccion.crearPath('"+ idSelect +"')>"+nombre+"</a>";

                    }).catch(function (error) {
                        console.log(error)
                    })
                }
            },
            methods:{
                getSubCat: function (id) {
                axios.get('/API/subCategories', {
                    params: {
                        id: id
                    }
                }).then(function (response) {

                    var array = response.data.subCategories.children_categories;

                    if (typeof array !== 'undefined' && array.length > 0) {
                        select = this.document.getElementById("select");
                        idSelect = select.value;
                        nombre = select.options[select.selectedIndex].innerHTML;
                        document.getElementById("path").innerHTML = document.getElementById("path").innerHTML + ">" + "<a href='#' onclick=seleccion.crearPath2('"+ response.data.subCategories.id +"')>"+response.data.subCategories.name+"</a>";

                        seleccion.categories = response.data.subCategories.children_categories
                    } else {
                        $('#myModal').modal({ show: false});
                        $('#myModal').modal('show');



                        seleccion.id = response.data.subCategories.id;
                        seleccion.name = response.data.subCategories.name;
                        seleccion.picture = response.data.subCategories.picture;
                        seleccion.totalItems = response.data.subCategories.total_items_in_this_category;

                        document.getElementById("imgLI").src = seleccion.picture;




                    }
                }).catch(function (error) {
                    console.log(error)
                })
                },
                crearPath: function (id) {

                    axios.get('/API/categories', {
                        params: {
                            selected: id
                        }
                    }).then(function (response) {

                        seleccion.categories = response.data.categories;
                        console.log(seleccion.categories);
                    }).catch(function (error) {
                        console.log(error)
                    })
                },
                crearPath2: function (id) {
                    axios.get('/API/subCategories', {
                        params: {
                            id: id
                        }
                    }).then(function (response) {

                        document.getElementById("path").innerHTML = "";
                        document.getElementById("path").innerHTML = primerPath;

                        for(i = 0; i < response.data.subCategories.path_from_root.length; i++){
                            document.getElementById("path").innerHTML = document.getElementById("path").innerHTML + " -> <a href='#' onclick=seleccion.crearPath2('"+response.data.subCategories.path_from_root[i].id+"')>"+response.data.subCategories.path_from_root[i].name+"</a>";
                        }

                        seleccion.categories = response.data.subCategories.children_categories;
                        console.log(seleccion.categories);
                    }).catch(function (error) {
                        console.log(error)
                    })
                },
                deleteArticulo: function () {
                    axios.get('/API/deleteArticulo', {
                        params: {
                            id: this.id
                        }
                    }).then(function (response) {
                        alert("Se borró el articulo")
                    }).catch(function (error) {
                        console.log(error)
                    })
                },
                showEdit: function () {
                    document.getElementById("divEdit").hidden = false;
                },
                editArticulo: function () {
                    var data = {
                        "name": document.getElementById("editName").value,
                        "picture": document.getElementById("editPicture").value,
                       // "total_items_in_this_category": parseInt(this.$refs.totalItemsInput.value),
                        "marca": parseInt(document.getElementById("select").value),
                    }

                    axios.get('/API/editArticulo',{
                        params: {
                            id: this.id,
                            data: data
                        }
                    }).then(function (response) {
                    }).catch(function (error) {
                        console.log(error)
                    })
                },
                addArticulo: function () {
                    $('#modal2').modal({ show: false});
                    $('#modal2').modal('show');
                },
                saveArticulo: function () {
                    var data = {
                        "name": document.getElementById("addName").value,
                        "picture": document.getElementById("addPicture").value,
                        "marca": parseInt(document.getElementById("select").value),
                    }

                    axios.get('/API/addArticulo',{
                        params: {
                            data: data
                        }
                    }).then(function (response) {
                    }).catch(function (error) {
                        console.log(error)
                    })
                }
            }

        })
    </script>



</body>
</html>