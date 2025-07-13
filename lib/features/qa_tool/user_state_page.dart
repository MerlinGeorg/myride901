import 'package:flutter/material.dart';
import 'package:myride901/features/subscription/subscription_bloc.dart';

class UserStatePage extends StatefulWidget {
  @override
  _UserStatePageState createState() => _UserStatePageState();
}

class _UserStatePageState extends State<UserStatePage> {
  bool _toggleValue = false;
  bool _toggleTrialEndValue = false;
  final _subscriptionBloc = SubscriptionBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('User State'),
      ),
      body: FutureBuilder(
        future: _subscriptionBloc.getUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final subscriptionState = _subscriptionBloc.subscriptionState;
            final isTrial = subscriptionState['isTrial'];
            _toggleValue = isTrial;
            final shouldReminderTrialEnd =
                subscriptionState['shouldReminderTrialEnd'];
            _toggleTrialEndValue = shouldReminderTrialEnd;

            final subDetail =
                _subscriptionBloc.productsPurchased.isEmpty == false
                    ? _subscriptionBloc.productsPurchased.last
                    : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      'Subscription State for user ${_subscriptionBloc.loginData?.user?.id}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      '(hasProAccess) Pro features enabled: ${subscriptionState['hasProAccess'] ? 'Yes' : 'No'}'),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      Text('Trial status : ${isTrial ? 'active' : 'inactive'}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      '(isTrialStarted) User has already started a trial: ${subscriptionState['isTrialStarted'] ? 'Yes' : 'No'}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      'Trial end date : ${subscriptionState['trialEndDate'] ?? "null"}'),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      '(isSubscribed) User has subscription active: ${subscriptionState['isSubscribed'] ? 'Yes' : 'No'}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      '(isSecondtime) User already subscribed once: ${subscriptionState['isSecondTime'] ? 'Yes' : 'No'}'),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      'Last subscription name ${subscriptionState['subscriptionName'] ?? "null"}'),
                ),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Subscription has to be cancelled in Play store app on Android or in Settings app on iOS',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Enable/Disable trial period'),
                        trailing: Switch(
                          value: _toggleValue,
                          onChanged: (bool value) async {
                            debugPrint(
                                "---> value $value _toggleValue $_toggleValue");

                            await _subscriptionBloc.updateTrialStatus(value);
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        title: Text('Enable/Disable end trial popup'),
                        subtitle:
                            Text('Works only if 2 days before trial end date'),
                        trailing: Switch(
                          value: _toggleTrialEndValue,
                          onChanged: (bool value) async {
                            debugPrint(
                                "---> value $value _toggleTrialEndValue $_toggleTrialEndValue");
                            await _subscriptionBloc
                                .updateReminderEndTrialPopup(value);

                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        title: Text('Reset user state as fresh user'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            bool? confirmed = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text(
                                      'Make sure you also cancel subscription in Play Store and Settings app'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(false); // Return false
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(true); // Return true
                                      },
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed == true) {
                              await _subscriptionBloc
                                  .resetUserSubscriptionInfos();
                              setState(() {});
                            }
                          },
                          child: Text('Reset'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
