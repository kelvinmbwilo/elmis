/*
 * Electronic Logistics Management Information System (eLMIS) is a supply chain management system for health commodities in a developing country setting.
 *
 * Copyright (C) 2015  John Snow, Inc (JSI). This program was produced for the U.S. Agency for International Development (USAID). It was prepared under the USAID | DELIVER PROJECT, Task Order 4.
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openlmis.ivdform.service;

import org.junit.Test;
import org.junit.experimental.categories.Category;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.openlmis.db.categories.UnitTests;
import org.openlmis.ivdform.domain.config.VaccineIvdTabVisibility;
import org.openlmis.ivdform.repository.TabVisibilityRepository;

import java.util.List;

import static java.util.Arrays.asList;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.mockito.Mockito.*;


@Category(UnitTests.class)
@RunWith(MockitoJUnitRunner.class)
public class VaccineIvdTabVisibilityServiceTest {

  @Mock
  TabVisibilityRepository repository;

  @InjectMocks
  TabVisibilityService service;

  @Test
  public void shouldGetAllPossibleVisibilityForProgram() throws Exception {
    List<VaccineIvdTabVisibility> list = asList(new VaccineIvdTabVisibility());

    when(repository.getVisibilityForProgram(2L)).thenReturn(null);
    when(repository.getAllVisibilityConfiguration()).thenReturn(list);

    List<VaccineIvdTabVisibility> result = service.getVisibilityForProgram(2L);
    assertThat(result, is(list));
  }

  @Test
  public void shouldGetSavedVisibilityForProgram() throws Exception {
    List<VaccineIvdTabVisibility> list = asList(new VaccineIvdTabVisibility());

    when(repository.getVisibilityForProgram(2L)).thenReturn(list);
    when(repository.getAllVisibilityConfiguration()).thenReturn(null);

    List<VaccineIvdTabVisibility> result = service.getVisibilityForProgram(2L);
    assertThat(result, is(list));

    verify(repository, never()).getAllVisibilityConfiguration();
  }

  @Test
  public void shouldSave() throws Exception {
    VaccineIvdTabVisibility visibility = new VaccineIvdTabVisibility();
    VaccineIvdTabVisibility visibility1 = new VaccineIvdTabVisibility();
    visibility.setId(23L);
    List<VaccineIvdTabVisibility> list = asList(visibility, visibility1);

    service.save(list, 2L);
    verify(repository).insert(visibility1);
    verify(repository).update(visibility);
  }
}