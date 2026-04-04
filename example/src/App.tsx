import { Text, View, StyleSheet } from 'react-native';
import { attest } from 'react-native-app-attestation';

const result = attest('SGlNeU5hbWVJc1Rlc3Rpbmc=');
result
  ?.then((attestResult) => {
    console.log('attestResult token', attestResult.token);
    console.log('attestResult keyId', attestResult.keyId);
  })
  .catch((exception) => {
    console.log('exception:: ', exception);
  });
export default function App() {
  return (
    <View style={styles.container}>
      <Text>Result: </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
