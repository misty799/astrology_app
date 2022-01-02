import 'package:astrology_app/Bloc/astrologer_bloc.dart';
import 'package:astrology_app/Bloc/astrologer_event.dart';
import 'package:astrology_app/Models/astrologer.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String searchedName = '';
  late AstrologerBloc _astrologerBloc;
  @override
  void didChangeDependencies() {
    _astrologerBloc = BlocProvider.of<AstrologerBloc>(context);
    _astrologerBloc.astrologerEventSink.add(FetchAstrologer());
    super.didChangeDependencies();
  }

  bool isSearching = false;
  searchWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1)],
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.orange,
          ),
          Expanded(
              child: TextField(
            onChanged: (value) {
              setState(() {
                searchedName = value.toLowerCase();
              });
            },
            decoration: const InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Search Astrologer',
                hintStyle: TextStyle(fontSize: 12)),
          )),
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: const Icon(Icons.close),
            color: Colors.orange,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Talk to an Astrologer",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  isSearching = true;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/search.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              Image.asset(
                "assets/filter.png",
                width: 25,
                height: 25,
              ),
              PopupMenuButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/sort.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                  itemBuilder: (context) {
                    return List.generate(4, (i) {
                      return PopupMenuItem(
                        onTap: () {
                          _astrologerBloc.astrologerEventSink
                              .add(FetchSortedAstrologer(index: i));
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey)),
                                ),
                              ),
                              Flexible(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _sortingList[i],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ))
                            ]),
                        value: _sortingList[i],
                      );
                    });
                  }),
            ],
          ),
          if (isSearching) searchWidget(),
          Expanded(
            child: StreamBuilder<List<Astrologer>>(
                stream: _astrologerBloc.astrologerDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Astrologer> data = snapshot.data!
                        .where((element) => element.firstName
                            .toLowerCase()
                            .contains(searchedName))
                        .toList();
                    return ListView.separated(
                        separatorBuilder: (context, i) {
                          return Divider();
                        },
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          return AstrologerDetailsWidget(astrologer: data[i]);
                        });
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      !snapshot.hasData) {
                    return const Center(
                      child: Text("no data"),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    ));
  }

  final List<String> _sortingList = [
    'Experience- high to low',
    'Experience- low to high',
    'Price- high to low',
    'Price- low to high'
  ];
}

class AstrologerDetailsWidget extends StatelessWidget {
  final Astrologer astrologer;
  const AstrologerDetailsWidget({Key? key, required this.astrologer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          astrologer.imageUrl,
          height: 100,
          width: 100,
          fit: BoxFit.fill,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    astrologer.firstName + " " + astrologer.lastName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(astrologer.skills.join(', '))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    astrologer.languages.join(', '),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "\u{20B9} ${astrologer.price.toInt()}/min",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(right: 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.phone_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        "Talk on Call",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Text("${astrologer.experience}  Years")
      ],
    );
  }
}
