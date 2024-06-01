import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:fl_chart/fl_chart.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';
  List<String> _history = [];
  List<String> _savedFormulas = [];
  bool _isRad = true;
  bool _isInverse = false;

  void _numClick(String text) {
    setState(() {
      _expression += text;
    });
  }

  void _clear(String text) {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _allClear(String text) {
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    });
  }

  void _evaluate(String text) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = eval.toString();
        _history.add('$_expression = $_result');
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _saveFormula() {
    if (_expression.isNotEmpty) {
      setState(() {
        _savedFormulas.add(_expression);
      });
    }
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _history
              .map((e) => ListTile(
            title: Text(e),
          ))
              .toList(),
        );
      },
    );
  }

  void _showSavedFormulas() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _savedFormulas
              .map((e) => ListTile(
            title: Text(e),
            onTap: () {
              setState(() {
                _expression = e;
              });
              Navigator.pop(context);
            },
          ))
              .toList(),
        );
      },
    );
  }

  void _showUnitConversions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return UnitConversionWidget();
      },
    );
  }

  void _showGraphingCalculator() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GraphingCalculator();
      },
    );
  }

  void _toggleRadDeg() {
    setState(() {
      _isRad = !_isRad;
    });
  }

  void _toggleInverse() {
    setState(() {
      _isInverse = !_isInverse;
    });
  }

  Widget _buildButton(String text, Color textColor) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20.0),
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          if (text == 'C') {
            _clear(text);
          } else if (text == 'AC') {
            _allClear(text);
          } else if (text == '=') {
            _evaluate(text);
          } else {
            _numClick(text);
          }
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScientificButton(String text, Color textColor, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20.0),
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showHistory,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _showSavedFormulas,
          ),
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: _showUnitConversions,
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: _showGraphingCalculator,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _expression,
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _result,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.white),
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      _buildScientificButton('Rad', _isRad ? Colors.green : Colors.white, _toggleRadDeg),
                      _buildScientificButton('Deg', !_isRad ? Colors.green : Colors.white, _toggleRadDeg),
                      _buildScientificButton('x!', Colors.white, () => _numClick('!')),
                      _buildScientificButton('x²', Colors.white, () => _numClick('^2')),
                      _buildScientificButton(_isInverse ? 'sin⁻¹' : 'sin', Colors.white, () => _numClick(_isInverse ? 'asin(' : 'sin(')),
                      _buildScientificButton(_isInverse ? 'cos⁻¹' : 'cos', Colors.white, () => _numClick(_isInverse ? 'acos(' : 'cos(')),
                      _buildScientificButton(_isInverse ? 'tan⁻¹' : 'tan', Colors.white, () => _numClick(_isInverse ? 'atan(' : 'tan(')),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildScientificButton('Inv', _isInverse ? Colors.green : Colors.white, _toggleInverse),
                      _buildScientificButton('π', Colors.white, () => _numClick('pi')),
                      _buildScientificButton('e', Colors.white, () => _numClick('e')),
                      _buildScientificButton('log', Colors.white, () => _numClick('log(')),
                      _buildScientificButton('ln', Colors.white, () => _numClick('ln(')),
                      _buildScientificButton('√', Colors.white, () => _numClick('sqrt(')),
                      _buildScientificButton('^', Colors.white, () => _numClick('^')),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildButton('7', Colors.white),
                      _buildButton('8', Colors.white),
                      _buildButton('9', Colors.white),
                      _buildButton('(', Colors.white),
                      _buildButton(')', Colors.white),
                      _buildButton('/', Colors.orange),
                      _buildButton('*', Colors.orange),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildButton('4', Colors.white),
                      _buildButton('5', Colors.white),
                      _buildButton('6', Colors.white),
                      _buildButton('-', Colors.orange),
                      _buildButton('+', Colors.orange),
                      _buildButton('C', Colors.red),
                      _buildButton('AC', Colors.red),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      _buildButton('1', Colors.white),
                      _buildButton('2', Colors.white),
                      _buildButton('3', Colors.white),
                      _buildButton('0', Colors.white),
                      _buildButton('.', Colors.white),
                      _buildButton('=', Colors.green),
                      _buildScientificButton('Save', Colors.blue, _saveFormula),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnitConversionWidget extends StatefulWidget {
  @override
  _UnitConversionWidgetState createState() => _UnitConversionWidgetState();
}

class _UnitConversionWidgetState extends State<UnitConversionWidget> {
  double _inputValue = 0.0;
  String _fromUnit = 'meters';
  String _toUnit = 'kilometers';
  String _result = '';
  String _conversionCategory = 'Length';

  final Map<String, Map<String, double>> _conversionRates = {
    'Length': {
      'meters': 1.0,
      'kilometers': 0.001,
      'centimeters': 100.0,
      'millimeters': 1000.0,
      'miles': 0.000621371,
      'yards': 1.09361,
      'feet': 3.28084,
      'inches': 39.3701,
    },
    'Weight': {
      'grams': 1.0,
      'kilograms': 0.001,
      'milligrams': 1000.0,
      'pounds': 0.00220462,
      'ounces': 0.035274,
    },
    'Temperature': {
      'Celsius': 1.0,
      'Fahrenheit': 1.8,
      'Kelvin': 1.0,
    }
  };

  void _convert() {
    if (_conversionCategory == 'Temperature') {
      double convertedValue;
      if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
        convertedValue = (_inputValue * 1.8) + 32;
      } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
        convertedValue = (_inputValue - 32) / 1.8;
      } else if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') {
        convertedValue = _inputValue + 273.15;
      } else if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') {
        convertedValue = _inputValue - 273.15;
      } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') {
        convertedValue = (_inputValue - 32) / 1.8 + 273.15;
      } else if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') {
        convertedValue = (_inputValue - 273.15) * 1.8 + 32;
      } else {
        convertedValue = _inputValue; // Same unit
      }
      setState(() {
        _result = '$convertedValue $_toUnit';
      });
    } else {
      double fromRate = _conversionRates[_conversionCategory]![_fromUnit]!;
      double toRate = _conversionRates[_conversionCategory]![_toUnit]!;
      double convertedValue = _inputValue * (toRate / fromRate);
      setState(() {
        _result = '$convertedValue $_toUnit';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButton<String>(
            value: _conversionCategory,
            items: _conversionRates.keys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _conversionCategory = newValue!;
                _fromUnit = _conversionRates[_conversionCategory]!.keys.first;
                _toUnit = _conversionRates[_conversionCategory]!.keys.first;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter value'),
            onChanged: (value) {
              _inputValue = double.tryParse(value) ?? 0.0;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DropdownButton<String>(
                value: _fromUnit,
                items: _conversionRates[_conversionCategory]!.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _fromUnit = newValue!;
                  });
                },
              ),
              Text('to'),
              DropdownButton<String>(
                value: _toUnit,
                items: _conversionRates[_conversionCategory]!.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _toUnit = newValue!;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            child: Text('Convert'),
            onPressed: _convert,
          ),
          SizedBox(height: 16.0),
          Text(
            _result,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class GraphingCalculator extends StatefulWidget {
  @override
  _GraphingCalculatorState createState() => _GraphingCalculatorState();
}

class _GraphingCalculatorState extends State<GraphingCalculator> {
  String _expression = '';
  List<FlSpot> _points = [];

  void _plotGraph() {
    List<FlSpot> points = [];
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      for (double x = -10; x <= 10; x += 0.1) {
        cm.bindVariableName('x', Number(x));
        double y = exp.evaluate(EvaluationType.REAL, cm);
        points.add(FlSpot(x, y));
      }
      setState(() {
        _points = points;
      });
    } catch (e) {
      setState(() {
        _points = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphing Calculator'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Enter expression'),
              onChanged: (value) {
                _expression = value;
              },
            ),
            ElevatedButton(
              child: Text('Plot'),
              onPressed: _plotGraph,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Container(
                height: 300,
                child: _points.isNotEmpty
                    ? LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(showTitles: true),
                            bottomTitles: SideTitles(showTitles: true),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _points,
                              isCurved: false,
                              barWidth: 2,
                              colors: [Colors.blue],
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'Enter a valid expression to plot',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
