// Unit tests for the Team Workspace networking foundation.
//
// (Widget/integration tests are pending — see CLAUDE.md → Testing.)
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/pages/projects/model/project_model.dart';

void main() {
  group('PagedResult', () {
    test('parses backend paged envelope', () {
      final result = PagedResult<ProjectModel>.fromJson(
        {
          'items': [
            {'id': 'p1', 'workspaceId': 'w1', 'name': 'Alpha', 'status': 'Active', 'priority': 'High'},
          ],
          'page': 1,
          'pageSize': 20,
          'totalCount': 1,
          'totalPages': 1,
        },
        ProjectModel.fromJson,
      );

      expect(result.items.length, 1);
      expect(result.items.first.name, 'Alpha');
      expect(result.items.first.status, ProjectStatus.active);
      expect(result.items.first.priority, ProjectPriority.high);
      expect(result.hasNextPage, isFalse);
    });

    test('PageParams clamps page size to the backend maximum', () {
      const params = PageParams(page: 2, pageSize: 500, search: 'x');
      final query = params.toQuery();
      expect(query['pageSize'], PageParams.maxPageSize);
      expect(query['page'], 2);
      expect(query['search'], 'x');
    });
  });

  group('Domain enum parsing', () {
    test('maps API strings to enums with safe fallback', () {
      expect(taskStatusFromApi('InProgress'), TaskItemStatus.inProgress);
      expect(taskStatusFromApi('Nonexistent'), TaskItemStatus.todo);
      expect(projectStatusFromApi('OnHold'), ProjectStatus.onHold);
    });
  });
}
