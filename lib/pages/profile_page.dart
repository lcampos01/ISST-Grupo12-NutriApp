import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

//import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {
  bool isObscurePassword = true;
  TextEditingController _date = TextEditingController();
  String? _selectedActivity = "moderado";
  List<MultiSelectItem<String>> _allergens = [
                                'Lactosa',
                                'Gluten',
                                'Huevos',
                                'Crustáceos',
                                'Pescado',
                                'Frutos Secos',
                                'Soja',
  ].map((allergen) => MultiSelectItem<String>(allergen, allergen)).toList();
  List<String> _selectedAllergens = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(left: 15, top: 20, right:15),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children : [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white), 
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1)
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://images.genius.com/a9306e944a04741a70c74429fb6b2b5e.1000x1000x1.jpg'
                            )
                          )
                        ),

                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,

                        child: Container(
                            height:40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Colors.green
                            ),
                            color: Colors.white
                          ),
                          child: Icon(
                            Icons.edit,
                            color:Colors.green,
                            )
                        )
                      )
                    ],
                  ),
                  
                  ),
                  SizedBox(height:30),
                  buildTextField("Nombre Completo", "BENY JR", false),
                  buildTextField("Correo Electrónico", "beny@jr.com", false),
                  buildTextField("Contraseña", "********", true),
                  
                  //Fecha nacimiento
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextField(
                      controller: _date,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: ()async{
                        DateTime? pickeddate = await showDatePicker(
                          context: context, 
                          initialDate: DateTime.now(), 
                          firstDate: DateTime(1900), 
                          lastDate: DateTime(2100)
                          );

                        if(pickeddate != null){
                          setState((){
                            _date.text = DateFormat("dd-MM-yyyy").format(pickeddate);
                          });
                        }
                        
                      },
                          icon: Icon(Icons.calendar_today_rounded),
                          color: Colors.grey,
                        ),
                        labelText: "Fecha de Nacimiento",
                      ),

                    ),
                    
                  ),


                  //Cuadros Peso y Altura
                  buildNumericField("Peso en Kg", "80.7"),
                  buildNumericField("Altura en metros", "1.92"),

                  //Actividad Física

                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Actividad física',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedActivity,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedActivity = newValue;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: 'activo',
                          child: Text('Activo'), 
                        ),
                        DropdownMenuItem<String>(
                          value: 'moderado',
                          child: Text('Moderado'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'sedentario',
                          child: Text('Sedentario'),
                        ),
                      ],
                    ),
                  ),

                  //Alergenos

                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Intolerancias Alimenticias",
                        
                      ),
                      child: InkWell(
                        onTap: () {
                          _showMultiSelect(context); // Llama a la función de selección múltiple
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Seleccionar alergenos"),
                            Icon(Icons.add_circle_outline_outlined, color: Colors.grey),
                            
                          ],
                        ),
                      ),
                    ),
                  ),

                  MultiSelectChipDisplay(
                    items: _selectedAllergens.map((e) => MultiSelectItem(e, e)).toList(),
                    onTap: (value) {
                      setState(() {
                        _selectedAllergens.remove(value);
                      });
                    },
                    chipColor: Colors.white,
                    textStyle: TextStyle(color: Colors.green),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), 
                    //                              side: BorderSide(color: Colors.green, width: 4)
                    ),

                    ),
                  

                  //Botones

                  SizedBox(height:30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: (){},
                        child: Text("Cerrar Sesión", style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.black
                        )
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          

                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){},
                        child: Text("Guardar Cambios", style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.white,
                        )),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal:20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

                      ),

                      ),
                    ],
                  ),

                  SizedBox(height:50),
              ],
            ),
          ),
        
        
        ),
    );
  }

    void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return  MultiSelectDialog(
          items: _allergens,
          initialValue: _selectedAllergens,
          onConfirm: (values) {
            setState(() {
              _selectedAllergens = values; // Actualiza la lista de alergenos seleccionados
          });},
        );
      },
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isPasswordTextField){
    return Padding(
      padding: EdgeInsets.only(bottom:30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword: false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField ? 
            IconButton(
              onPressed: (){
                setState((){
                  isObscurePassword = !isObscurePassword;
                });
              },
              icon: Icon(Icons.remove_red_eye, color: Colors.grey),
              ): null,
            contentPadding:  EdgeInsets.only(bottom: 5),
            labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey
              )

        )
        ),
      );

  }

  Widget buildNumericField(String labelText, String placeholder) {
  return Padding(
    padding: EdgeInsets.only(bottom: 30),
    child: TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 5),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: placeholder,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey
        )
      )
    ),
  );
  }

}