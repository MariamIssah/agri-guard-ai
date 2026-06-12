import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/ghana_locations.dart';
import '../utils/mock_produce_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String? _regionFilter;

  List<ProduceRecord> get _results {
    var list = searchProduce(_query);
    if (_regionFilter != null && _regionFilter != 'All Regions') {
      list = list.where((r) => r.region == _regionFilter).toList();
    }
    return list;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Produce')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search crops, regions, farmers, or harvests',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: quickSearchCrops
                  .map(
                    (crop) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(crop),
                        onPressed: () {
                          _controller.text = crop;
                          setState(() => _query = crop);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: DropdownButtonFormField<String>(
              initialValue: _regionFilter ?? 'All Regions',
              decoration: const InputDecoration(
                labelText: 'Filter by Region',
                prefixIcon: Icon(Icons.map_outlined),
                isDense: true,
              ),
              items: regionFilterOptions
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _regionFilter = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_results.length} result(s)',
                style: TextStyle(
                  fontSize: 13,
                  color: AgriColors.soilBrown.withValues(alpha: 0.65),
                ),
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(
                      'No produce found. Try another search.',
                      style: TextStyle(
                        color: AgriColors.soilBrown.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_query.isNotEmpty) ...[
                        Text(
                          'By location',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AgriColors.soilBrown.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...groupByLocation(_results).map(_locationCard),
                        const SizedBox(height: 16),
                        Text(
                          'Individual records',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AgriColors.soilBrown.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      ..._results.map(_recordCard),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _locationCard(ProduceLocationSummary s) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AgriColors.forestGreen.withValues(alpha: 0.04),
      child: ListTile(
        leading: const Icon(Icons.place_rounded, color: AgriColors.forestGreen),
        title: Text(
          '${s.town}, ${s.region} Region',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AgriColors.soilBrown,
          ),
        ),
        subtitle: Text(
          '${s.crop}\n'
          'Predicted quantity: ${s.predictedQuantity}\n'
          'Farmers: ${s.farmerCount}',
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _recordCard(ProduceRecord r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AgriColors.leafGreen.withValues(alpha: 0.15),
          child:
              const Icon(Icons.grass_rounded, color: AgriColors.forestGreen),
        ),
        title: Text(
          r.crop,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AgriColors.soilBrown,
          ),
        ),
        subtitle: Text(
          '${r.town}, ${r.region} · ${r.district}\n'
          'Farmer: ${r.farmer}\n'
          'Qty: ${r.quantity} · Harvest: ${r.harvest}',
        ),
        isThreeLine: true,
        trailing: Text(
          r.confidence,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AgriColors.forestGreen,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
