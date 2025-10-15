import { NavigationContainer } from "@react-navigation/native";
import { createStackNavigator } from "@react-navigation/stack";
import HomeScreen from "./screens/HomeScreen.js/index.js";
import NotesScreen from "./screens/NotesScreen.js/index.js";

const Stack = createStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen
          name="Home"
          component={HomeScreen}
          options={{
            title: "Notes App",
            headerStyle: {
              backgroundColor: "#f4511e",
            },
            headerTintColor: "#fff",
          }}
        />
        <Stack.Screen
          name="Notes"
          component={NotesScreen}
          options={{
            title: "My Notes",
          }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}