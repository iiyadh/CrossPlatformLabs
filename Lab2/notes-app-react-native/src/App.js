import React from 'react';
import { SafeAreaView, StatusBar, StyleSheet } from 'react-native';
import NotesScreen from './screens/NotesScreen';

const App = () => {
  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />
      <NotesScreen />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
});

export default App;